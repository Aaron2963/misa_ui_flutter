final Map<String, dynamic> mockSchema = {
  "\$schema": "http://json-schema.org/draft-06/schema#",
  "title": "Counter Info",
  "@table": "CNRIFO",
  "type": "object",
  "properties": {
    "CNRIFOID": {
      "type": "string",
      "component": "hidden",
      "formOnly": true,
      "readonly": true
    },
    "Name": {
      "type": "string",
      "title": "Name",
      "component": "editbox",
      "purpose": ["header", "caption"]
    },
    "CNRIFOTYPID": {
      "type": "string",
      "title": "Counter Type",
      "component": "select",
      "formOnly": true,
      "@chain": [
        {
          "@table": "CNRIFOTYP:Brief",
          "@id": "CNRIFOTYPID",
          "type": "object",
          "properties": {
            "CNRIFOTYPID": {"type": "string", "@column": "CNRIFOTYPID"},
            "Name": {
              "type": "string",
              "purpose": ["caption"]
            }
          }
        }
      ]
    },
    "_CNRIFOTYPName": {
      "type": "string",
      "title": "Counter Type",
      "component": "editbox",
      "readonly": true
    },
    "BKGDCP": {
      "type": "string",
      "title": "Background Description",
      "component": "textarea",
      "purpose": ["option"]
    },
    "GNLDCP": {
      "type": "string",
      "title": "General Description",
      "component": "textarea",
      "purpose": ["option"]
    },
    "_Pictures": {
      "type": "array",
      "title": "Pictures",
      "items": {
        "type": "object",
        "title": "",
        "properties": {
          "_PictureFile": {
            "type": "string",
            "title": "Picture File",
            "component": "image"
          },
          "_PictureTitle": {
            "type": "string",
            "title": "Picture Title",
            "component": "editbox"
          },
          "_PictureAlt": {
            "type": "string",
            "title": "Picture Alt",
            "component": "editbox"
          }
        }
      }
    },
    "StartDateTime": {
      "type": "string",
      "title": "Start Time",
      "component": "datetime",
      "purpose": ["header"]
    },
    "EndDateTime": {
      "type": "string",
      "title": "End Time",
      "component": "datetime",
      "purpose": ["header"]
    },
    "TargetPath": {
      "type": "string",
      "title": "Target Link",
      "component": "editbox",
      "purpose": ["option"]
    },
    "SlottingState": {
      "type": "boolean",
      "title": "On Sale",
      "component": "select",
      "enum": ["On", "Off"],
      "texts": ["On Sale", "Not On Sale"],
      "value": "Off",
      "purpose": ["header"]
    },
    "SlottingSEQ": {
      "type": "integer",
      "title": "Sequence",
      "component": "number"
    },
    "ModifyDateTime": {
      "type": "string",
      "title": "Last Modified",
      "component": "editbox",
      "purpose": ["timeline"],
      "readonly": true
    }
  },
  "filter": [
    "CNRIFOID",
    "Name",
    "_CNRIFOTYPName",
    "StartDateTime",
    "EndDateTime",
    "TargetPath",
    "SlottingState",
    "ModifyDateTime"
  ],
  "@id": "CNRIFOID",
  "dependentRequired": {
    "insert": [
      "Name",
      "CNRIFOTYPID",
      "StartDateTime",
      "EndDateTime",
      "SlottingState"
    ],
    "edit": [
      "Name",
      "CNRIFOTYPID",
      "StartDateTime",
      "EndDateTime",
      "SlottingState"
    ]
  }
};
