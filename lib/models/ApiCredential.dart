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


/** This is an auto generated class representing the ApiCredential type in your schema. */
class ApiCredential extends amplify_core.Model {
  static const classType = const _ApiCredentialModelType();
  final String id;
  final String? _name;
  final String? _apiKeyHash;
  final bool? _active;
  final String? _allowedIps;
  final amplify_core.TemporalDateTime? _expiresAt;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ApiCredentialModelIdentifier get modelIdentifier {
      return ApiCredentialModelIdentifier(
        id: id
      );
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get apiKeyHash {
    try {
      return _apiKeyHash!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get active {
    try {
      return _active!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get allowedIps {
    return _allowedIps;
  }
  
  amplify_core.TemporalDateTime? get expiresAt {
    return _expiresAt;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ApiCredential._internal({required this.id, required name, required apiKeyHash, required active, allowedIps, expiresAt, createdAt, updatedAt}): _name = name, _apiKeyHash = apiKeyHash, _active = active, _allowedIps = allowedIps, _expiresAt = expiresAt, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ApiCredential({String? id, required String name, required String apiKeyHash, required bool active, String? allowedIps, amplify_core.TemporalDateTime? expiresAt, amplify_core.TemporalDateTime? createdAt}) {
    return ApiCredential._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      apiKeyHash: apiKeyHash,
      active: active,
      allowedIps: allowedIps,
      expiresAt: expiresAt,
      createdAt: createdAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiCredential &&
      id == other.id &&
      _name == other._name &&
      _apiKeyHash == other._apiKeyHash &&
      _active == other._active &&
      _allowedIps == other._allowedIps &&
      _expiresAt == other._expiresAt &&
      _createdAt == other._createdAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ApiCredential {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("apiKeyHash=" + "$_apiKeyHash" + ", ");
    buffer.write("active=" + (_active != null ? _active!.toString() : "null") + ", ");
    buffer.write("allowedIps=" + "$_allowedIps" + ", ");
    buffer.write("expiresAt=" + (_expiresAt != null ? _expiresAt!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ApiCredential copyWith({String? name, String? apiKeyHash, bool? active, String? allowedIps, amplify_core.TemporalDateTime? expiresAt, amplify_core.TemporalDateTime? createdAt}) {
    return ApiCredential._internal(
      id: id,
      name: name ?? this.name,
      apiKeyHash: apiKeyHash ?? this.apiKeyHash,
      active: active ?? this.active,
      allowedIps: allowedIps ?? this.allowedIps,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt);
  }
  
  ApiCredential copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<String>? apiKeyHash,
    ModelFieldValue<bool>? active,
    ModelFieldValue<String?>? allowedIps,
    ModelFieldValue<amplify_core.TemporalDateTime?>? expiresAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt
  }) {
    return ApiCredential._internal(
      id: id,
      name: name == null ? this.name : name.value,
      apiKeyHash: apiKeyHash == null ? this.apiKeyHash : apiKeyHash.value,
      active: active == null ? this.active : active.value,
      allowedIps: allowedIps == null ? this.allowedIps : allowedIps.value,
      expiresAt: expiresAt == null ? this.expiresAt : expiresAt.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value
    );
  }
  
  ApiCredential.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _apiKeyHash = json['apiKeyHash'],
      _active = json['active'],
      _allowedIps = json['allowedIps'],
      _expiresAt = json['expiresAt'] != null ? amplify_core.TemporalDateTime.fromString(json['expiresAt']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'apiKeyHash': _apiKeyHash, 'active': _active, 'allowedIps': _allowedIps, 'expiresAt': _expiresAt?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'apiKeyHash': _apiKeyHash,
    'active': _active,
    'allowedIps': _allowedIps,
    'expiresAt': _expiresAt,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ApiCredentialModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ApiCredentialModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final APIKEYHASH = amplify_core.QueryField(fieldName: "apiKeyHash");
  static final ACTIVE = amplify_core.QueryField(fieldName: "active");
  static final ALLOWEDIPS = amplify_core.QueryField(fieldName: "allowedIps");
  static final EXPIRESAT = amplify_core.QueryField(fieldName: "expiresAt");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ApiCredential";
    modelSchemaDefinition.pluralName = "ApiCredentials";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.READ,
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ApiCredential.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ApiCredential.APIKEYHASH,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ApiCredential.ACTIVE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ApiCredential.ALLOWEDIPS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ApiCredential.EXPIRESAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ApiCredential.CREATEDAT,
      isRequired: false,
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

class _ApiCredentialModelType extends amplify_core.ModelType<ApiCredential> {
  const _ApiCredentialModelType();
  
  @override
  ApiCredential fromJson(Map<String, dynamic> jsonData) {
    return ApiCredential.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ApiCredential';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ApiCredential] in your schema.
 */
class ApiCredentialModelIdentifier implements amplify_core.ModelIdentifier<ApiCredential> {
  final String id;

  /** Create an instance of ApiCredentialModelIdentifier using [id] the primary key. */
  const ApiCredentialModelIdentifier({
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
  String toString() => 'ApiCredentialModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ApiCredentialModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}