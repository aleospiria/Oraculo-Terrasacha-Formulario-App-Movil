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


/** This is an auto generated class representing the AccessDeadline type in your schema. */
class AccessDeadline extends amplify_core.Model {
  static const classType = const _AccessDeadlineModelType();
  final String id;
  final SubjectType? _subjectType;
  final String? _subjectKey;
  final amplify_core.TemporalDateTime? _deadline;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AccessDeadlineModelIdentifier get modelIdentifier {
      return AccessDeadlineModelIdentifier(
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
  
  amplify_core.TemporalDateTime get deadline {
    try {
      return _deadline!;
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
  
  const AccessDeadline._internal({required this.id, required subjectType, required subjectKey, required deadline, createdAt, updatedAt}): _subjectType = subjectType, _subjectKey = subjectKey, _deadline = deadline, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory AccessDeadline({String? id, required SubjectType subjectType, required String subjectKey, required amplify_core.TemporalDateTime deadline, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return AccessDeadline._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      subjectType: subjectType,
      subjectKey: subjectKey,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccessDeadline &&
      id == other.id &&
      _subjectType == other._subjectType &&
      _subjectKey == other._subjectKey &&
      _deadline == other._deadline &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AccessDeadline {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("subjectType=" + (_subjectType != null ? amplify_core.enumToString(_subjectType)! : "null") + ", ");
    buffer.write("subjectKey=" + "$_subjectKey" + ", ");
    buffer.write("deadline=" + (_deadline != null ? _deadline!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AccessDeadline copyWith({SubjectType? subjectType, String? subjectKey, amplify_core.TemporalDateTime? deadline, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return AccessDeadline._internal(
      id: id,
      subjectType: subjectType ?? this.subjectType,
      subjectKey: subjectKey ?? this.subjectKey,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  AccessDeadline copyWithModelFieldValues({
    ModelFieldValue<SubjectType>? subjectType,
    ModelFieldValue<String>? subjectKey,
    ModelFieldValue<amplify_core.TemporalDateTime>? deadline,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return AccessDeadline._internal(
      id: id,
      subjectType: subjectType == null ? this.subjectType : subjectType.value,
      subjectKey: subjectKey == null ? this.subjectKey : subjectKey.value,
      deadline: deadline == null ? this.deadline : deadline.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  AccessDeadline.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _subjectType = amplify_core.enumFromString<SubjectType>(json['subjectType'], SubjectType.values),
      _subjectKey = json['subjectKey'],
      _deadline = json['deadline'] != null ? amplify_core.TemporalDateTime.fromString(json['deadline']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'subjectType': amplify_core.enumToString(_subjectType), 'subjectKey': _subjectKey, 'deadline': _deadline?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'subjectType': _subjectType,
    'subjectKey': _subjectKey,
    'deadline': _deadline,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<AccessDeadlineModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<AccessDeadlineModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SUBJECTTYPE = amplify_core.QueryField(fieldName: "subjectType");
  static final SUBJECTKEY = amplify_core.QueryField(fieldName: "subjectKey");
  static final DEADLINE = amplify_core.QueryField(fieldName: "deadline");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AccessDeadline";
    modelSchemaDefinition.pluralName = "AccessDeadlines";
    
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
      key: AccessDeadline.SUBJECTTYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AccessDeadline.SUBJECTKEY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AccessDeadline.DEADLINE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AccessDeadline.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AccessDeadline.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _AccessDeadlineModelType extends amplify_core.ModelType<AccessDeadline> {
  const _AccessDeadlineModelType();
  
  @override
  AccessDeadline fromJson(Map<String, dynamic> jsonData) {
    return AccessDeadline.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'AccessDeadline';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [AccessDeadline] in your schema.
 */
class AccessDeadlineModelIdentifier implements amplify_core.ModelIdentifier<AccessDeadline> {
  final String id;

  /** Create an instance of AccessDeadlineModelIdentifier using [id] the primary key. */
  const AccessDeadlineModelIdentifier({
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
  String toString() => 'AccessDeadlineModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AccessDeadlineModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}