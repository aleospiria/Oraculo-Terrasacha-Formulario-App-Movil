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


/** This is an auto generated class representing the RoutePermission type in your schema. */
class RoutePermission extends amplify_core.Model {
  static const classType = const _RoutePermissionModelType();
  final String id;
  final SubjectType? _subjectType;
  final String? _subjectKey;
  final String? _tagName;
  final String? _method;
  final bool? _allow;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  RoutePermissionModelIdentifier get modelIdentifier {
      return RoutePermissionModelIdentifier(
        id: id
      );
  }
  
  SubjectType get subjectType {
    try {
      return _subjectType!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get subjectKey {
    try {
      return _subjectKey!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get tagName {
    try {
      return _tagName!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get method {
    try {
      return _method!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get allow {
    try {
      return _allow!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const RoutePermission._internal({required this.id, required subjectType, required subjectKey, required tagName, required method, required allow, createdAt, updatedAt}): _subjectType = subjectType, _subjectKey = subjectKey, _tagName = tagName, _method = method, _allow = allow, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory RoutePermission({String? id, required SubjectType subjectType, required String subjectKey, required String tagName, required String method, required bool allow, amplify_core.TemporalDateTime? createdAt}) {
    return RoutePermission._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      subjectType: subjectType,
      subjectKey: subjectKey,
      tagName: tagName,
      method: method,
      allow: allow,
      createdAt: createdAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutePermission &&
      id == other.id &&
      _subjectType == other._subjectType &&
      _subjectKey == other._subjectKey &&
      _tagName == other._tagName &&
      _method == other._method &&
      _allow == other._allow &&
      _createdAt == other._createdAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("RoutePermission {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("subjectType=" + (_subjectType != null ? amplify_core.enumToString(_subjectType)! : "null") + ", ");
    buffer.write("subjectKey=" + "$_subjectKey" + ", ");
    buffer.write("tagName=" + "$_tagName" + ", ");
    buffer.write("method=" + "$_method" + ", ");
    buffer.write("allow=" + (_allow != null ? _allow!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  RoutePermission copyWith({SubjectType? subjectType, String? subjectKey, String? tagName, String? method, bool? allow, amplify_core.TemporalDateTime? createdAt}) {
    return RoutePermission._internal(
      id: id,
      subjectType: subjectType ?? this.subjectType,
      subjectKey: subjectKey ?? this.subjectKey,
      tagName: tagName ?? this.tagName,
      method: method ?? this.method,
      allow: allow ?? this.allow,
      createdAt: createdAt ?? this.createdAt);
  }
  
  RoutePermission copyWithModelFieldValues({
    ModelFieldValue<SubjectType>? subjectType,
    ModelFieldValue<String>? subjectKey,
    ModelFieldValue<String>? tagName,
    ModelFieldValue<String>? method,
    ModelFieldValue<bool>? allow,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt
  }) {
    return RoutePermission._internal(
      id: id,
      subjectType: subjectType == null ? this.subjectType : subjectType.value,
      subjectKey: subjectKey == null ? this.subjectKey : subjectKey.value,
      tagName: tagName == null ? this.tagName : tagName.value,
      method: method == null ? this.method : method.value,
      allow: allow == null ? this.allow : allow.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value
    );
  }
  
  RoutePermission.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _subjectType = amplify_core.enumFromString<SubjectType>(json['subjectType'], SubjectType.values),
      _subjectKey = json['subjectKey'],
      _tagName = json['tagName'],
      _method = json['method'],
      _allow = json['allow'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'subjectType': amplify_core.enumToString(_subjectType), 'subjectKey': _subjectKey, 'tagName': _tagName, 'method': _method, 'allow': _allow, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'subjectType': _subjectType,
    'subjectKey': _subjectKey,
    'tagName': _tagName,
    'method': _method,
    'allow': _allow,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<RoutePermissionModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<RoutePermissionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SUBJECTTYPE = amplify_core.QueryField(fieldName: "subjectType");
  static final SUBJECTKEY = amplify_core.QueryField(fieldName: "subjectKey");
  static final TAGNAME = amplify_core.QueryField(fieldName: "tagName");
  static final METHOD = amplify_core.QueryField(fieldName: "method");
  static final ALLOW = amplify_core.QueryField(fieldName: "allow");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "RoutePermission";
    modelSchemaDefinition.pluralName = "RoutePermissions";
    
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
      key: RoutePermission.SUBJECTTYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutePermission.SUBJECTKEY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutePermission.TAGNAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutePermission.METHOD,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutePermission.ALLOW,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: RoutePermission.CREATEDAT,
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

class _RoutePermissionModelType extends amplify_core.ModelType<RoutePermission> {
  const _RoutePermissionModelType();
  
  @override
  RoutePermission fromJson(Map<String, dynamic> jsonData) {
    return RoutePermission.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'RoutePermission';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [RoutePermission] in your schema.
 */
class RoutePermissionModelIdentifier implements amplify_core.ModelIdentifier<RoutePermission> {
  final String id;

  /** Create an instance of RoutePermissionModelIdentifier using [id] the primary key. */
  const RoutePermissionModelIdentifier({
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
  String toString() => 'RoutePermissionModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is RoutePermissionModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}