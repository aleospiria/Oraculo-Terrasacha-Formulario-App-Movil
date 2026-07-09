/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the User type in your schema. */
class User extends amplify_core.Model {
  static const classType = const _UserModelType();
  final String id;
  final String? _departamento;
  final String? _municipio;
  final List<UserModelPackage>? _user_model_packages;
  final List<Calculation>? _calculations;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserModelIdentifier get modelIdentifier {
      return UserModelIdentifier(
        id: id
      );
  }
  
  String? get departamento {
    return _departamento;
  }
  
  String? get municipio {
    return _municipio;
  }
  
  List<UserModelPackage>? get user_model_packages {
    return _user_model_packages;
  }
  
  List<Calculation>? get calculations {
    return _calculations;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const User._internal({required this.id, departamento, municipio, user_model_packages, calculations, createdAt, updatedAt}): _departamento = departamento, _municipio = municipio, _user_model_packages = user_model_packages, _calculations = calculations, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory User({String? id, String? departamento, String? municipio, List<UserModelPackage>? user_model_packages, List<Calculation>? calculations}) {
    return User._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      departamento: departamento,
      municipio: municipio,
      user_model_packages: user_model_packages != null ? List<UserModelPackage>.unmodifiable(user_model_packages) : user_model_packages,
      calculations: calculations != null ? List<Calculation>.unmodifiable(calculations) : calculations);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _departamento == other._departamento &&
      _municipio == other._municipio &&
      DeepCollectionEquality().equals(_user_model_packages, other._user_model_packages) &&
      DeepCollectionEquality().equals(_calculations, other._calculations);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("departamento=" + "$_departamento" + ", ");
    buffer.write("municipio=" + "$_municipio" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? departamento, String? municipio, List<UserModelPackage>? user_model_packages, List<Calculation>? calculations}) {
    return User._internal(
      id: id,
      departamento: departamento ?? this.departamento,
      municipio: municipio ?? this.municipio,
      user_model_packages: user_model_packages ?? this.user_model_packages,
      calculations: calculations ?? this.calculations);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<String?>? departamento,
    ModelFieldValue<String?>? municipio,
    ModelFieldValue<List<UserModelPackage>?>? user_model_packages,
    ModelFieldValue<List<Calculation>?>? calculations
  }) {
    return User._internal(
      id: id,
      departamento: departamento == null ? this.departamento : departamento.value,
      municipio: municipio == null ? this.municipio : municipio.value,
      user_model_packages: user_model_packages == null ? this.user_model_packages : user_model_packages.value,
      calculations: calculations == null ? this.calculations : calculations.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _departamento = json['departamento'],
      _municipio = json['municipio'],
      _user_model_packages = json['user_model_packages']  is Map
        ? (json['user_model_packages']['items'] is List
          ? (json['user_model_packages']['items'] as List)
              .where((e) => e != null)
              .map((e) => UserModelPackage.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['user_model_packages'] is List
          ? (json['user_model_packages'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => UserModelPackage.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _calculations = json['calculations']  is Map
        ? (json['calculations']['items'] is List
          ? (json['calculations']['items'] as List)
              .where((e) => e != null)
              .map((e) => Calculation.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['calculations'] is List
          ? (json['calculations'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Calculation.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'departamento': _departamento, 'municipio': _municipio, 'user_model_packages': _user_model_packages?.map((UserModelPackage? e) => e?.toJson()).toList(), 'calculations': _calculations?.map((Calculation? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'departamento': _departamento,
    'municipio': _municipio,
    'user_model_packages': _user_model_packages,
    'calculations': _calculations,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<UserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final DEPARTAMENTO = amplify_core.QueryField(fieldName: "departamento");
  static final MUNICIPIO = amplify_core.QueryField(fieldName: "municipio");
  static final USER_MODEL_PACKAGES = amplify_core.QueryField(
    fieldName: "user_model_packages",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserModelPackage'));
  static final CALCULATIONS = amplify_core.QueryField(
    fieldName: "calculations",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Calculation'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.DEPARTAMENTO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.MUNICIPIO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.USER_MODEL_PACKAGES,
      isRequired: false,
      ofModelName: 'UserModelPackage',
      associatedKey: UserModelPackage.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.CALCULATIONS,
      isRequired: false,
      ofModelName: 'Calculation',
      associatedKey: Calculation.USER
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _UserModelType extends amplify_core.ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'User';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [User] in your schema.
 */
class UserModelIdentifier implements amplify_core.ModelIdentifier<User> {
  final String id;

  /** Create an instance of UserModelIdentifier using [id] the primary key. */
  const UserModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'UserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}