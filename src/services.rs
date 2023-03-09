use crate::{AppState, TokenClaims};
use actix_web::{
    get, post,
    web::{Data, Json, ReqData},
    HttpResponse, Responder,
};
use actix_web_httpauth::extractors::basic::BasicAuth;
use argonautica::{Hasher, Verifier};
use chrono::{NaiveDateTime, NaiveDate};
use hmac::{Hmac, Mac};
use jwt::SignWithKey;
use serde::{Deserialize, Serialize};
use sha2::Sha256;
use sqlx::{self, FromRow};

#[derive(Deserialize)]
struct CreateUserBody {
    username: String,
    password: String,
}

#[derive(Serialize, FromRow)]
struct UserNoPassword {
    id: i64,
    username: String,
}

#[derive(Serialize, FromRow)]
struct AuthUser {
    id: i64,
    username: String,
    password: String,
}

#[derive(Deserialize)]
struct CreateArticleBody {
    title: String,
    content: String,
}

#[derive(Serialize, FromRow)]
struct Article {
    id: i32,
    title: String,
    content: String,
    published_by: i32,
    published_on: Option<NaiveDateTime>,
}

#[derive(Serialize, FromRow)]
struct UserMeal {
    meal_type: String,
    description: String,
    meal_date: NaiveDate,
}

#[derive(Deserialize)]
struct UserMealRequest {
      meal_type: String,
      meal_date: String,
}

 #[derive(Deserialize)]
struct UserMealTotalRequest {
      meal_date: String
}



#[derive(Serialize, Debug)]
struct Food {
    name: String,
    data_type: String,
    fdc_id: i64,
    mealid: i64,
    mealtype: String,
    mealdate: String,
    nutrient_list: Vec<Nutrient>
}

#[derive(Serialize, Debug)]
struct NutrientMealInfo {
    total_protein: f64,
    total_fat: f64,
    total_carbs: f64,
    total_calories: f64,
    final_meal_list: Vec<Food>
}

#[derive(Serialize, Debug)]
struct Nutrient {
    name: String,
    amount: f64
}


#[derive(Serialize, Debug)]
struct TotalCalories {
    total_calories_breakfast: f64,
    total_calories_lunch: f64,
    total_calories_dinner: f64,
    total_calories_snack: f64,
    total_calories_burnt: f64
}


#[post("/user")]
async fn create_user(state: Data<AppState>, body: Json<CreateUserBody>) -> impl Responder {
    let user: CreateUserBody = body.into_inner();

    let firstname = String::from("John");
    let lastname = String::from("Miller");


    let hash_secret = std::env::var("HASH_SECRET").expect("HASH_SECRET must be set!");
    let mut hasher = Hasher::default();
    let hash = hasher
        .with_password(user.password)
        .with_secret_key(hash_secret)
        .hash()
        .unwrap();

    match sqlx::query_as::<_, UserNoPassword>(
        "INSERT INTO users (username, password, firstname, lastname)
        VALUES ($1, $2, $3, $4)
        RETURNING id, username",
    )
    .bind(user.username)
    .bind(hash)
    .bind(firstname)
    .bind(lastname)
    .fetch_one(&state.db)
    .await
    {
        Ok(user) => HttpResponse::Ok().json(user),
        Err(error) => HttpResponse::InternalServerError().json(format!("{:?}", error)),
    }
}

#[get("/auth")]
async fn basic_auth(state: Data<AppState>, credentials: BasicAuth) -> impl Responder {
    let jwt_secret: Hmac<Sha256> = Hmac::new_from_slice(
        std::env::var("JWT_SECRET")
            .expect("JWT_SECRET must be set!")
            .as_bytes(),
    )
    .unwrap();
    let username = credentials.user_id();
    let password = credentials.password();

    match password {
        None => HttpResponse::Unauthorized().json("Must provide username and password"),
        Some(pass) => {
            match sqlx::query_as::<_, AuthUser>(
                "SELECT id, username, password FROM users WHERE username = $1",
            )
            .bind(username.to_string())
            .fetch_one(&state.db)
            .await
            {
                Ok(user) => {
                    let hash_secret =
                        std::env::var("HASH_SECRET").expect("HASH_SECRET must be set!");
                    let mut verifier = Verifier::default();
                    let is_valid = verifier
                        .with_hash(user.password)
                        .with_password(pass)
                        .with_secret_key(hash_secret)
                        .verify()
                        .unwrap();

                    if is_valid {
                        let claims = TokenClaims { id: user.id };
                        let token_str = claims.sign_with_key(&jwt_secret).unwrap();
                        HttpResponse::Ok().json(token_str)
                    } else {
                        HttpResponse::Unauthorized().json("Incorrect username or password")
                    }
                }
                Err(error) => HttpResponse::InternalServerError().json(format!("{:?}", error)),
            }
        }
    }
}

#[post("/usermeals")]
async fn get_meals (
    state: Data<AppState>,
    req_user: Option<ReqData<TokenClaims>>,
    body: Json<UserMealRequest>,
) -> impl Responder {
    match req_user {
        Some(user) => {
            let usermealrequest: UserMealRequest = body.into_inner();
            let meal_date = NaiveDate::parse_from_str(&usermealrequest.meal_date, "%Y-%m-%d").unwrap();

            let mut meal_list: Vec<Food> = Vec::new();


            let mut totalprotein = 0.0;
            let mut totalfat = 0.0;
            let mut totalcarbs = 0.0;
            let mut totalcalories = 0.0;


            let mymeals = sqlx::query!(
                "SELECT * from meal_plan 
                WHERE meal_date=$1 AND meal_type=$2 AND userid=$3",
               meal_date, usermealrequest.meal_type, i64::from(user.id)
            )
            .fetch_all(&state.db)
            .await
            .unwrap();
           
            for meal in mymeals.iter() {
                //println!("{}", r.fdc_id.unwrap());
                let foods = sqlx::query!(
                    "SELECT * from food 
                    WHERE fdc_id=$1",
                    meal.fdc_id.unwrap() 
                )
                .fetch_all(&state.db)
                .await
                .unwrap();
               for food in foods.iter(){

                    let food_nutrients = sqlx::query!(
                        "SELECT * from food_nutrient_original
                        WHERE fdc_id=$1",
                        food.fdc_id
                    )
                    .fetch_all(&state.db)
                    .await
                    .unwrap();
                    
                    //let mut l = Vec::new();

                  let mut nutr_list: Vec<Nutrient> = Vec::new();
                
                    for f_n in food_nutrients.iter() {

                        let nutrient = sqlx::query!(
                            "SELECT * from nutrient 
                            WHERE id=$1",
                            f_n.nutrient_id
                        )
                        .fetch_one(&state.db)
                        .await
                        .unwrap();
                        
                            let nutr = Nutrient {
                                name: String::from(nutrient.name.as_ref().unwrap()),
                                amount: f_n.amount.unwrap()
                           };
                           nutr_list.push(nutr);

                                if f_n.nutrient_id == 1003 {
                                  totalprotein += f_n.amount.unwrap();
                                } 
                               if f_n.nutrient_id == 1004 {
                                totalfat += f_n.amount.unwrap();
                               } 
                              if f_n.nutrient_id == 1005 {
                                totalcarbs += f_n.amount.unwrap();
                              }
                              if f_n.nutrient_id == 1008 {
                                totalcalories += f_n.amount.unwrap();
                              }


                }

                let  food_struct = Food {
                    name: String::from(food.description.as_ref().unwrap()),
                    data_type: String::from(food.data_type.as_ref().unwrap()),
                    fdc_id: food.fdc_id,
                    mealid: meal.id,
                    mealtype: String::from(&meal.meal_type),
                    mealdate: NaiveDate::to_string(&meal.meal_date),
                    nutrient_list: nutr_list
                };
                

                  meal_list.push(food_struct);
                }    

            }
            println!("{:?}", meal_list);

            let nutrient_meal_info = NutrientMealInfo{
                total_protein: totalprotein.round(),
                total_fat: totalfat.round(),
                total_carbs: totalcarbs.round(),
                total_calories: totalcalories.round(),
                final_meal_list: meal_list
            };

            HttpResponse::Ok().json(nutrient_meal_info)
        }
        _ => HttpResponse::Unauthorized().json("Unable to verify identity"),
    }

}


#[post("/usermealtotals")]
async fn get_meal_totals (
    state: Data<AppState>,
    req_user: Option<ReqData<TokenClaims>>,
    body: Json<UserMealTotalRequest>,
) -> impl Responder {
    match req_user {
        Some(user) => {
            let usermealtotalrequest: UserMealTotalRequest = body.into_inner();
            let meal_date = NaiveDate::parse_from_str(&usermealtotalrequest.meal_date, "%Y-%m-%d").unwrap();

            let mut totalcalories_breakfast = 0.0;
            let mut totalcalories_lunch = 0.0;
            let mut totalcalories_dinner = 0.0;
            let mut totalcalories_snack = 0.0;
            let mut totalcalories_burnt: f64 = 0.0;

            let mymeals = sqlx::query!(
                "SELECT * from meal_plan 
                WHERE meal_date=$1 AND userid=$2",
               meal_date, i64::from(user.id)
            )
            .fetch_all(&state.db)
            .await
            .unwrap();
           
            for meal in mymeals.iter() {
                let foods = sqlx::query!(
                    "SELECT * from food 
                    WHERE fdc_id=$1",
                    meal.fdc_id.unwrap() 
                )
                .fetch_all(&state.db)
                .await
                .unwrap();
               for food in foods.iter(){

                    let food_nutrients = sqlx::query!(
                        "SELECT * from food_nutrient_original
                        WHERE fdc_id=$1",
                        food.fdc_id
                    )
                    .fetch_all(&state.db)
                    .await
                    .unwrap();
                    
                    for f_n in food_nutrients.iter() {

                             if f_n.nutrient_id == 1008 && meal.meal_type == "Breakfast" {
                                totalcalories_breakfast += f_n.amount.unwrap();
                              }
                              if f_n.nutrient_id == 1008 && meal.meal_type == "Lunch" {
                                totalcalories_lunch += f_n.amount.unwrap();
                              }

                              if f_n.nutrient_id == 1008 && meal.meal_type == "Dinner" {
                                totalcalories_dinner += f_n.amount.unwrap();
                              }
                              if f_n.nutrient_id == 1008 && meal.meal_type == "Snack" {
                                totalcalories_snack += f_n.amount.unwrap();
                              }
                }
                }    
            }

            let myexercises = sqlx::query!(
                "SELECT timemins, met FROM exercise_plan 
                JOIN met_values 
                ON exercise_plan.metid = met_values.id 
                WHERE edate=$1 and userid=$2;
                ",
               meal_date, i64::from(user.id)
            )
            .fetch_all(&state.db)
            .await
            .unwrap();

            for exercise in myexercises.iter() {
                totalcalories_burnt = totalcalories_burnt + (exercise.timemins as f64 * exercise.met.unwrap());
            }

            let total_calories_info = TotalCalories {
                total_calories_breakfast: totalcalories_breakfast.round(),
                total_calories_lunch: totalcalories_lunch.round(),
                total_calories_dinner: totalcalories_dinner.round(),
                total_calories_snack: totalcalories_snack.round(),
                total_calories_burnt: totalcalories_burnt.round()
            };

            HttpResponse::Ok().json(total_calories_info)
        }
        _ => HttpResponse::Unauthorized().json("Unable to verify identity"),
    }

}


