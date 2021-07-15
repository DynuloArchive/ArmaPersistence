use std::sync::RwLock;

use log::{Level, LevelFilter, Metadata, Record};

use arma_rs::{rv, rv_callback, rv_handler};

#[macro_use]
extern crate log;

#[macro_use]
extern crate lazy_static;

lazy_static! {
    static ref HOST: String = std::env::var("DYNULO_PERSISTENCE_HOST")
        .unwrap_or_else(|_| "https://dev.dynulo.com/persistence".to_string());
    static ref TOKEN: RwLock<String> = RwLock::new(String::new());
    static ref KEY: RwLock<String> = RwLock::new(String::new());
}

mod objects;
use objects::Object;
mod groups;
use groups::Group;
mod units;
use units::Unit;
mod markers;
use markers::Marker;

#[rv]
fn setup(token: String, key: String) -> bool {
    if token.is_empty() {
        false
    } else {
        *TOKEN.write().unwrap() = token;
        if key.is_empty() {
            false
        } else {
            *KEY.write().unwrap() = key;
            true
        }
    }
}

#[rv]
fn uuid() -> String {
    ::uuid::Uuid::new_v4().to_string()
}

#[rv(thread = true)]
fn save_object(id: String, class: String, position: String, rotation: String, variables: String) {
    if let Err(e) = objects::internal_save(Object {
        id,
        class,
        position,
        rotation,
        variables: variables.replace("\"\"", "\""),
    }) {
        error!("Error saving object: {}", e);
    }
}

#[rv(thread = true)]
fn get_objects() {
    match objects::internal_get() {
        Ok(o) => {
            for i in o {
                rv_callback!(
                    "dynulo_persistence",
                    "object",
                    i.id,
                    i.class,
                    i.position,
                    i.rotation,
                    i.variables
                );
            }
        }
        Err(e) => {
            error!("Error getting objects: {}", e);
        }
    }
    rv_callback!("dynulo_persistence", "objects_complete");
}

#[rv(thread = true)]
fn delete_object(id: String) {
    if let Err(e) = objects::internal_delete(id) {
        error!("Error deleting object: {}", e);
    }
}

#[rv(thread = true)]
fn save_group(
    id: String,
    side: String,
    variables: String,
) {
    if let Err(e) = groups::internal_save(Group {
        id,
        side,
        variables: variables.replace("\"\"", "\""),
    }) {
        error!("Error saving group: {}", e);
    }
}

#[rv(thread = true)]
fn get_groups() {
    match groups::internal_get() {
        Ok(o) => {
            for i in o {
                rv_callback!(
                    "dynulo_persistence",
                    "group",
                    i.id,
                    i.side,
                    i.variables
                );
            }
        }
        Err(e) => {
            error!("Error getting groups: {}", e);
        }
    }
    rv_callback!("dynulo_persistence", "groups_complete");
}

#[rv(thread = true)]
fn delete_group(id: String) {
    if let Err(e) = groups::internal_delete(id) {
        error!("Error deleting group: {}", e);
    }
}

#[rv(thread = true)]
fn save_marker(id: String, position: String, variables: String) {
    if let Err(e) = markers::internal_save(Marker {
        id,
        position,
        variables: variables.replace("\"\"", "\""),
    }) {
        error!("Error saving marker: {}", e);
    }
}

// get_markers
#[rv(thread = true)]
fn get_markers() {
    match markers::internal_get() {
        Ok(o) => {
            for i in o {
                rv_callback!(
                    "dynulo_persistence",
                    "marker",
                    i.id,
                    i.variables
                );
            }
        }
        Err(e) => {
            error!("Error getting markers: {}", e);
        }
    }
    rv_callback!("dynulo_persistence", "markers_complete");
}

#[rv(thread = true)]
fn delete_marker(id: String) {
    if let Err(e) = markers::internal_delete(id) {
        error!("Error deleting marker: {}", e);
    }
}

#[rv(thread = true)]
fn save_unit(
    id: String,
    class: String,
    groupid: String,
    position: String,
    rotation: String,
    variables: String,
) {
    if let Err(e) = units::internal_save(Unit {
        id,
        class,
        groupid,
        position,
        rotation,
        variables: variables.replace("\"\"", "\""),
    }) {
        error!("Error saving unit: {}", e);
    }
}

#[rv(thread = true)]
fn get_units() {
    match units::internal_get() {
        Ok(o) => {
            for i in o {
                rv_callback!(
                    "dynulo_persistence",
                    "unit",
                    i.id,
                    i.class,
                    i.groupid,
                    i.position,
                    i.rotation,
                    i.variables
                );
            }
        }
        Err(e) => {
            error!("Error getting units: {}", e);
        }
    }
    rv_callback!("dynulo_persistence", "units_complete");
}

// delete a unit
#[rv(thread = true)]
fn delete_unit(id: String) {
    if let Err(e) = units::internal_delete(id) {
        error!("Error deleting unit: {}", e);
    }
}

struct ArmaLogger;

impl log::Log for ArmaLogger {
    fn enabled(&self, metadata: &Metadata) -> bool {
        metadata.level() <= Level::Info
    }

    fn log(&self, record: &Record) {
        if self.enabled(record.metadata()) {
            rv_callback!(
                "dynulo_persistence_log",
                format!("{}", record.level()).to_uppercase(),
                format!("{}", record.args())
            );
        }
    }

    fn flush(&self) {}
}
static LOGGER: ArmaLogger = ArmaLogger;

#[rv_handler]
fn init() {
    log::set_logger(&LOGGER).map(|()| log::set_max_level(LevelFilter::Info));
}
