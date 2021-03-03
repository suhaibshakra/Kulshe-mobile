// To parse this JSON data, do
//
//     final sections = sectionsFromJson(jsonString);

import 'dart:convert';

List<Sections> sectionsFromJson(String str) => List<Sections>.from(json.decode(str).map((x) => Sections.fromJson(x)));

String sectionsToJson(List<Sections> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sections {
  Sections({
    this.customMessage,
    this.customCode,
    this.data,
    this.tokenData,
    this.encrypt,
  });

  String customMessage;
  int customCode;
  List<Datum> data;
  TokenData tokenData;
  bool encrypt;

  factory Sections.fromJson(Map<String, dynamic> json) => Sections(
    customMessage: json["custom_message"],
    customCode: json["custom_code"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    tokenData: TokenData.fromJson(json["token_data"]),
    encrypt: json["encrypt"],
  );

  Map<String, dynamic> toJson() => {
    "custom_message": customMessage,
    "custom_code": customCode,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "token_data": tokenData.toJson(),
    "encrypt": encrypt,
  };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.label,
    this.slug,
    this.metaTitle,
    this.active,
    this.icon,
    this.createdAt,
    this.subSections,
  });

  int id;
  String name;
  Label label;
  Label slug;
  Label metaTitle;
  bool active;
  String icon;
  DateTime createdAt;
  List<SubSection> subSections;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    label: Label.fromJson(json["label"]),
    slug: Label.fromJson(json["slug"]),
    metaTitle: Label.fromJson(json["meta_title"]),
    active: json["active"],
    icon: json["icon"] == null ? null : json["icon"],
    createdAt: DateTime.parse(json["created_at"]),
    subSections: List<SubSection>.from(json["sub_sections"].map((x) => SubSection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "label": label.toJson(),
    "slug": slug.toJson(),
    "meta_title": metaTitle.toJson(),
    "active": active,
    "icon": icon == null ? null : icon,
    "created_at": createdAt.toIso8601String(),
    "sub_sections": List<dynamic>.from(subSections.map((x) => x.toJson())),
  };
}

class Label {
  Label({
    this.ar,
    this.en,
  });

  String ar;
  String en;

  factory Label.fromJson(Map<String, dynamic> json) => Label(
    ar: json["ar"],
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "ar": ar,
    "en": en,
  };
}

class SubSection {
  SubSection({
    this.id,
    this.sectionId,
    this.name,
    this.label,
    this.slug,
    this.metaTitle,
    this.metaDesc,
    this.metaKeywords,
    this.isAdult,
    this.icon,
    this.isFree,
    this.hasBrand,
    this.delivery,
    this.attributes,
    this.brands,
  });

  int id;
  int sectionId;
  String name;
  Label label;
  Label slug;
  Label metaTitle;
  Label metaDesc;
  MetaKeywords metaKeywords;
  bool isAdult;
  String icon;
  bool isFree;
  bool hasBrand;
  int delivery;
  List<Attribute> attributes;
  List<Brand> brands;

  factory SubSection.fromJson(Map<String, dynamic> json) => SubSection(
    id: json["id"],
    sectionId: json["section_id"],
    name: json["name"],
    label: Label.fromJson(json["label"]),
    slug: Label.fromJson(json["slug"]),
    metaTitle: Label.fromJson(json["meta_title"]),
    metaDesc: Label.fromJson(json["meta_desc"]),
    metaKeywords: MetaKeywords.fromJson(json["meta_keywords"]),
    isAdult: json["is_adult"],
    icon: json["icon"] == null ? null : json["icon"],
    isFree: json["is_free"],
    hasBrand: json["has_brand"],
    delivery: json["delivery"],
    attributes: List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "section_id": sectionId,
    "name": name,
    "label": label.toJson(),
    "slug": slug.toJson(),
    "meta_title": metaTitle.toJson(),
    "meta_desc": metaDesc.toJson(),
    "meta_keywords": metaKeywords.toJson(),
    "is_adult": isAdult,
    "icon": icon == null ? null : icon,
    "is_free": isFree,
    "has_brand": hasBrand,
    "delivery": delivery,
    "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
    "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
  };
}

class Attribute {
  Attribute({
    this.id,
    this.name,
    this.label,
    this.slug,
    this.hasChild,
    this.hasUnit,
    this.attributeId,
    this.active,
    this.config,
    this.createdAt,
    this.options,
    this.units,
  });

  int id;
  String name;
  Label label;
  dynamic slug;
  int hasChild;
  int hasUnit;
  int attributeId;
  int active;
  AttributeConfig config;
  DateTime createdAt;
  List<Option> options;
  List<Unit> units;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: json["id"],
    name: json["name"],
    label: Label.fromJson(json["label"]),
    slug: json["slug"],
    hasChild: json["has_child"],
    hasUnit: json["has_unit"],
    attributeId: json["attribute_id"],
    active: json["active"],
    config: AttributeConfig.fromJson(json["config"]),
    createdAt: DateTime.parse(json["created_at"]),
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    units: List<Unit>.from(json["units"].map((x) => Unit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "label": label.toJson(),
    "slug": slug,
    "has_child": hasChild,
    "has_unit": hasUnit,
    "attribute_id": attributeId,
    "active": active,
    "config": config.toJson(),
    "created_at": createdAt.toIso8601String(),
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
    "units": List<dynamic>.from(units.map((x) => x.toJson())),
  };
}

class AttributeConfig {
  AttributeConfig({
    this.max,
    this.min,
    this.icon,
    this.last,
    this.type,
    this.adult,
    this.first,
    this.onlist,
    this.prefix,
    this.suffix,
    this.searchType,
    this.searchable,
    this.validation,
  });

  String max;
  String min;
  String icon;
  dynamic last;
  String type;
  bool adult;
  dynamic first;
  bool onlist;
  String prefix;
  String suffix;
  SearchType searchType;
  bool searchable;
  Validation validation;

  factory AttributeConfig.fromJson(Map<String, dynamic> json) => AttributeConfig(
    max: json["max"] == null ? null : json["max"],
    min: json["min"] == null ? null : json["min"],
    icon: json["icon"] == null ? null : json["icon"],
    last: json["last"],
    type: json["type"],
    adult: json["adult"],
    first: json["first"],
    onlist: json["onlist"],
    prefix: json["prefix"] == null ? null : json["prefix"],
    suffix: json["suffix"] == null ? null : json["suffix"],
    searchType: searchTypeValues.map[json["searchType"]],
    searchable: json["searchable"],
    validation: validationValues.map[json["validation"]],
  );

  Map<String, dynamic> toJson() => {
    "max": max == null ? null : max,
    "min": min == null ? null : min,
    "icon": icon == null ? null : icon,
    "last": last,
    "type": type,
    "adult": adult,
    "first": first,
    "onlist": onlist,
    "prefix": prefix == null ? null : prefix,
    "suffix": suffix == null ? null : suffix,
    "searchType": searchTypeValues.reverse[searchType],
    "searchable": searchable,
    "validation": validationValues.reverse[validation],
  };
}

enum SearchType { MULTIPLE_CHECKBOX, YEAR, SELECT, NUMBER }

final searchTypeValues = EnumValues({
  "multiple_checkbox": SearchType.MULTIPLE_CHECKBOX,
  "number": SearchType.NUMBER,
  "select": SearchType.SELECT,
  "year": SearchType.YEAR
});

enum Validation { REQUIRED, VALIDATION_REQUIRED, REQUIRED_BETWEEN_2050 }

final validationValues = EnumValues({
  "Required": Validation.REQUIRED,
  "required|between:20:50": Validation.REQUIRED_BETWEEN_2050,
  "required": Validation.VALIDATION_REQUIRED
});

class Option {
  Option({
    this.id,
    this.name,
    this.label,
    this.config,
    this.attributeId,
  });

  int id;
  String name;
  Label label;
  dynamic config;
  int attributeId;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    name: json["name"],
    label: Label.fromJson(json["label"]),
    config: json["config"],
    attributeId: json["attribute_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "label": label.toJson(),
    "config": config,
    "attribute_id": attributeId,
  };
}

class Unit {
  Unit({
    this.isBased,
    this.config,
    this.unitId,
    this.attributeId,
    this.name,
    this.label,
  });

  int isBased;
  UnitConfig config;
  int unitId;
  int attributeId;
  String name;
  String label;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    isBased: json["is_based"],
    config: UnitConfig.fromJson(json["config"]),
    unitId: json["unit_id"],
    attributeId: json["attribute_id"],
    name: json["name"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "is_based": isBased,
    "config": config.toJson(),
    "unit_id": unitId,
    "attribute_id": attributeId,
    "name": name,
    "label": label,
  };
}

class UnitConfig {
  UnitConfig({
    this.convertValue,
  });

  String convertValue;

  factory UnitConfig.fromJson(Map<String, dynamic> json) => UnitConfig(
    convertValue: json["convertValue"] == null ? null : json["convertValue"],
  );

  Map<String, dynamic> toJson() => {
    "convertValue": convertValue == null ? null : convertValue,
  };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.label,
    this.slug,
    this.subBrands,
  });

  int id;
  String name;
  Label label;
  dynamic slug;
  List<SubBrand> subBrands;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    label: Label.fromJson(json["label"]),
    slug: json["slug"],
    subBrands: List<SubBrand>.from(json["sub_brands"].map((x) => SubBrand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "label": label.toJson(),
    "slug": slug,
    "sub_brands": List<dynamic>.from(subBrands.map((x) => x.toJson())),
  };
}

class SubBrand {
  SubBrand({
    this.id,
    this.brandId,
    this.name,
    this.label,
  });

  int id;
  int brandId;
  String name;
  Label label;

  factory SubBrand.fromJson(Map<String, dynamic> json) => SubBrand(
    id: json["id"],
    brandId: json["brand_id"],
    name: json["name"],
    label: Label.fromJson(json["label"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "brand_id": brandId,
    "name": name,
    "label": label.toJson(),
  };
}

class MetaKeywords {
  MetaKeywords({
    this.ar,
    this.en,
  });

  List<String> ar;
  List<String> en;

  factory MetaKeywords.fromJson(Map<String, dynamic> json) => MetaKeywords(
    ar: List<String>.from(json["ar"].map((x) => x)),
    en: json["en"] == null ? null : List<String>.from(json["en"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "ar": List<dynamic>.from(ar.map((x) => x)),
    "en": en == null ? null : List<dynamic>.from(en.map((x) => x)),
  };
}

class TokenData {
  TokenData();

  factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
  );

  Map<String, dynamic> toJson() => {
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
