class Cfg3DEN {
	class Object {
		class AttributeCategories {
			class DynuloPersistence {
				displayName = "Dynulo Persistence";
				class Attributes {
					class Ignore {
						//--- Mandatory properties
						displayName = "Ignore";
						tooltip = "This object is not persistent";
						property = QGVAR(attribute_ignmore);
						control = "Checkbox";

						//--- Optional
						expression = QUOTE(_this setVariable [QEGVAR(common,ignore), true]);
						defaultValue = false;
					};
				};
			};
		};
	};
};
