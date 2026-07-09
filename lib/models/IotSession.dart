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


/** This is an auto generated class representing the IotSession type in your schema. */
class IotSession extends amplify_core.Model {
  static const classType = const _IotSessionModelType();
  final String id;
  final String? _sessionId;
  final String? _iotData;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _expiresAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  IotSessionModelIdentifier get modelIdentifier {
      return IotSessionModelIdentifier(
        id: id
      );
  }
  
  String get sessionId {
    try {
      return _sessionId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get iotData {
    try {
      return _iotData!;
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
  
  amplify_core.TemporalDateTime get expiresAt {
    try {
      return _expiresAt!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const IotSession._internal({required this.id, required sessionId, required iotData, createdAt, required expiresAt, updatedAt}): _sessionId = sessionId, _iotData = iotData, _createdAt = createdAt, _expiresAt = expiresAt, _updatedAt = updatedAt;
  
  factory IotSession({String? id, required String sessionId, required String iotData, amplify_core.TemporalDateTime? createdAt, required amplify_core.TemporalDateTime expiresAt}) {
    return IotSession._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      sessionId: sessionId,
      iotData: iotData,
      createdAt: createdAt,
      expiresAt: expiresAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is IotSession &&
      id == other.id &&
      _sessionId == other._sessionId &&
      _iotData == other._iotData &&
      _createdAt == other._createdAt &&
      _expiresAt == other._expiresAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("IotSession {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sessionId=" + "$_sessionId" + ", ");
    buffer.write("iotData=" + "$_iotData" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("expiresAt=" + (_expiresAt != null ? _expiresAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  IotSession copyWith({String? sessionId, String? iotData, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? expiresAt}) {
    return IotSession._internal(
      id: id,
      sessionId: sessionId ?? this.sessionId,
      iotData: iotData ?? this.iotData,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt);
  }
  
  IotSession copyWithModelFieldValues({
    ModelFieldValue<String>? sessionId,
    ModelFieldValue<String>? iotData,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime>? expiresAt
  }) {
    return IotSession._internal(
      id: id,
      sessionId: sessionId == null ? this.sessionId : sessionId.value,
      iotData: iotData == null ? this.iotData : iotData.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      expiresAt: expiresAt == null ? this.expiresAt : expiresAt.value
    );
  }
  
  IotSession.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sessionId = json['sessionId'],
      _iotData = json['iotData'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _expiresAt = json['expiresAt'] != null ? amplify_core.TemporalDateTime.fromString(json['expiresAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sessionId': _sessionId, 'iotData': _iotData, 'createdAt': _createdAt?.format(), 'expiresAt': _expiresAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'sessionId': _sessionId,
    'iotData': _iotData,
    'createdAt': _createdAt,
    'expiresAt': _expiresAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<IotSessionModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<IotSessionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SESSIONID = amplify_core.QueryField(fieldName: "sessionId");
  static final IOTDATA = amplify_core.QueryField(fieldName: "iotData");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final EXPIRESAT = amplify_core.QueryField(fieldName: "expiresAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "IotSession";
    modelSchemaDefinition.pluralName = "IotSessions";
    
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
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["sessionId"], name: "bySessionId"),
      amplify_core.ModelIndex(fields: const ["expiresAt"], name: "byExpiresAt")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: IotSession.SESSIONID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: IotSession.IOTDATA,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: IotSession.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: IotSession.EXPIRESAT,
      isRequired: true,
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

class _IotSessionModelType extends amplify_core.ModelType<IotSession> {
  const _IotSessionModelType();
  
  @override
  IotSession fromJson(Map<String, dynamic> jsonData) {
    return IotSession.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'IotSession';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [IotSession] in your schema.
 */
class IotSessionModelIdentifier implements amplify_core.ModelIdentifier<IotSession> {
  final String id;

  /** Create an instance of IotSessionModelIdentifier using [id] the primary key. */
  const IotSessionModelIdentifier({
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
  String toString() => 'IotSessionModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is IotSessionModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}