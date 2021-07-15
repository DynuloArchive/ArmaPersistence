use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct Object {
    pub id: String,
    pub class: String,
    pub position: String,
    pub rotation: String,
    pub variables: String,
}

pub fn internal_get() -> Result<Vec<Object>, String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .get(&format!(
            "{}/v1/{}/objects",
            *crate::HOST,
            *crate::KEY.read().unwrap()
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<Vec<Object>>()
    {
        Ok(s) => Ok(s),
        Err(e) => Err(e.to_string()),
    }
}

pub fn internal_save(object: Object) -> Result<(), String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .post(&format!(
            "{}/v1/{}/objects",
            *crate::HOST,
            *crate::KEY.read().unwrap()
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&object)
        .send()
    {
        Ok(resp) => {
            if resp.status().is_success() {
                Ok(())
            } else {
                Err(resp.status().to_string())
            }
        }
        Err(e) => Err(e.to_string()),
    }
}

pub fn internal_delete(id: String) -> Result<(), String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .delete(&format!(
            "{}/v1/{}/objects/{}",
            *crate::HOST,
            *crate::KEY.read().unwrap(),
            id
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
    {
        Ok(resp) => {
            if resp.status().is_success() {
                Ok(())
            } else {
                Err(resp.status().to_string())
            }
        }
        Err(e) => Err(e.to_string()),
    }
}
