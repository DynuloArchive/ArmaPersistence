use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct Marker {
    pub id: String,
    pub position: String,
    pub variables: String,
}

pub fn internal_get() -> Result<Vec<Marker>, String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    match reqwest::blocking::Client::new()
        .get(&format!(
            "{}/v1/{}/markers",
            *crate::HOST,
            *crate::KEY.read().unwrap()
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .send()
        .unwrap()
        .json::<Vec<Marker>>()
    {
        Ok(s) => Ok(s.into_iter().map(|mut m| {
            if m.id.starts_with("-_-") {
                m.id = m.id.replace("-_-", "_USER_DEFINED #").replace("-", "/");
            }
            m
        }).collect()),
        Err(e) => Err(e.to_string()),
    }
}

pub fn internal_save(mut marker: Marker) -> Result<(), String> {
    if crate::TOKEN.read().unwrap().is_empty() {
        return Err(String::from("Empty token"));
    }
    marker.id = marker.id.replace("_USER_DEFINED #", "-_-").replace("/", "-");
    match reqwest::blocking::Client::new()
        .post(&format!(
            "{}/v1/{}/markers",
            *crate::HOST,
            *crate::KEY.read().unwrap()
        ))
        .header("x-dynulo-guild-token", &*crate::TOKEN.read().unwrap())
        .json(&marker)
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
    let id = id.replace("_USER_DEFINED #", "-_-").replace("/", "-");
    match reqwest::blocking::Client::new()
        .delete(&format!(
            "{}/v1/{}/markers/{}",
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
