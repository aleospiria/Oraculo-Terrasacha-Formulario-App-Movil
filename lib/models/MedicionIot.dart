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


/** This is an auto generated class representing the MedicionIot type in your schema. */
class MedicionIot extends amplify_core.Model {
  static const classType = const _MedicionIotModelType();
  final String id;
  final String? _deviceId;
  final String? _departamento;
  final String? _zona;
  final String? _variable;
  final double? _valor;
  final amplify_core.TemporalDateTime? _timestamp;
  final DispositivoIot? _dispositivo;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MedicionIotModelIdentifier get modelIdentifier {
      return MedicionIotModelIdentifier(
        id: id
      );
  }
  
  String get deviceId {
    try {
      return _deviceId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get departamento {
    try {
      return _departamento!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get zona {
    try {
      return _zona!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get variable {
    try {
      return _variable!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double get valor {
    try {
      return _valor!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get timestamp {
    try {
      return _timestamp!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  DispositivoIot? get dispositivo {
    return _dispositivo;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const MedicionIot._internal({required this.id, required deviceId, required departamento, required zona, required variable, required valor, required timestamp, dispositivo, createdAt, updatedAt}): _deviceId = deviceId, _departamento = departamento, _zona = zona, _variable = variable, _valor = valor, _timestamp = timestamp, _dispositivo = dispositivo, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory MedicionIot({String? id, required String deviceId, required String departamento, required String zona, required String variable, required double valor, required amplify_core.TemporalDateTime timestamp, DispositivoIot? dispositivo}) {
    return MedicionIot._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      deviceId: deviceId,
      departamento: departamento,
      zona: zona,
      variable: variable,
      valor: valor,
      timestamp: timestamp,
      dispositivo: dispositivo);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MedicionIot &&
      id == other.id &&
      _deviceId == other._deviceId &&
      _departamento == other._departamento &&
      _zona == other._zona &&
      _variable == other._variable &&
      _valor == other._valor &&
      _timestamp == other._timestamp &&
      _dispositivo == other._dispositivo;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MedicionIot {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("deviceId=" + "$_deviceId" + ", ");
    buffer.write("departamento=" + "$_departamento" + ", ");
    buffer.write("zona=" + "$_zona" + ", ");
    buffer.write("variable=" + "$_variable" + ", ");
    buffer.write("valor=" + (_valor != null ? _valor!.toString() : "null") + ", ");
    buffer.write("timestamp=" + (_timestamp != null ? _timestamp!.format() : "null") + ", ");
    buffer.write("dispositivo=" + (_dispositivo != null ? _dispositivo!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MedicionIot copyWith({String? deviceId, String? departamento, String? zona, String? variable, double? valor, amplify_core.TemporalDateTime? timestamp, DispositivoIot? dispositivo}) {
    return MedicionIot._internal(
      id: id,
      deviceId: deviceId ?? this.deviceId,
      departamento: departamento ?? this.departamento,
      zona: zona ?? this.zona,
      variable: variable ?? this.variable,
      valor: valor ?? this.valor,
      timestamp: timestamp ?? this.timestamp,
      dispositivo: dispositivo ?? this.dispositivo);
  }
  
  MedicionIot copyWithModelFieldValues({
    ModelFieldValue<String>? deviceId,
    ModelFieldValue<String>? departamento,
    ModelFieldValue<String>? zona,
    ModelFieldValue<String>? variable,
    ModelFieldValue<double>? valor,
    ModelFieldValue<amplify_core.TemporalDateTime>? timestamp,
    ModelFieldValue<DispositivoIot?>? dispositivo
  }) {
    return MedicionIot._internal(
      id: id,
      deviceId: deviceId == null ? this.deviceId : deviceId.value,
      departamento: departamento == null ? this.departamento : departamento.value,
      zona: zona == null ? this.zona : zona.value,
      variable: variable == null ? this.variable : variable.value,
      valor: valor == null ? this.valor : valor.value,
      timestamp: timestamp == null ? this.timestamp : timestamp.value,
      dispositivo: dispositivo == null ? this.dispositivo : dispositivo.value
    );
  }
  
  MedicionIot.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _deviceId = json['deviceId'],
      _departamento = json['departamento'],
      _zona = json['zona'],
      _variable = json['variable'],
      _valor = (json['valor'] as num?)?.toDouble(),
      _timestamp = json['timestamp'] != null ? amplify_core.TemporalDateTime.fromString(json['timestamp']) : null,
      _dispositivo = json['dispositivo'] != null
        ? json['dispositivo']['serializedData'] != null
          ? DispositivoIot.fromJson(new Map<String, dynamic>.from(json['dispositivo']['serializedData']))
          : DispositivoIot.fromJson(new Map<String, dynamic>.from(json['dispositivo']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'deviceId': _deviceId, 'departamento': _departamento, 'zona': _zona, 'variable': _variable, 'valor': _valor, 'timestamp': _timestamp?.format(), 'dispositivo': _dispositivo?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'deviceId': _deviceId,
    'departamento': _departamento,
    'zona': _zona,
    'variable': _variable,
    'valor': _valor,
    'timestamp': _timestamp,
    'dispositivo': _dispositivo,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MedicionIotModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MedicionIotModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final DEVICEID = amplify_core.QueryField(fieldName: "deviceId");
  static final DEPARTAMENTO = amplify_core.QueryField(fieldName: "departamento");
  static final ZONA = amplify_core.QueryField(fieldName: "zona");
  static final VARIABLE = amplify_core.QueryField(fieldName: "variable");
  static final VALOR = amplify_core.QueryField(fieldName: "valor");
  static final TIMESTAMP = amplify_core.QueryField(fieldName: "timestamp");
  static final DISPOSITIVO = amplify_core.QueryField(
    fieldName: "dispositivo",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'DispositivoIot'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MedicionIot";
    modelSchemaDefinition.pluralName = "MedicionIots";
    
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
      amplify_core.ModelIndex(fields: const ["dispositivoId"], name: "byDispositivo"),
      amplify_core.ModelIndex(fields: const ["deviceId"], name: "byDeviceId"),
      amplify_core.ModelIndex(fields: const ["timestamp"], name: "byTimestamp")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MedicionIot.DEVICEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MedicionIot.DEPARTAMENTO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MedicionIot.ZONA,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MedicionIot.VARIABLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MedicionIot.VALOR,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MedicionIot.TIMESTAMP,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: MedicionIot.DISPOSITIVO,
      isRequired: false,
      targetNames: ['dispositivoId'],
      ofModelName: 'DispositivoIot'
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

class _MedicionIotModelType extends amplify_core.ModelType<MedicionIot> {
  const _MedicionIotModelType();
  
  @override
  MedicionIot fromJson(Map<String, dynamic> jsonData) {
    return MedicionIot.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'MedicionIot';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [MedicionIot] in your schema.
 */
class MedicionIotModelIdentifier implements amplify_core.ModelIdentifier<MedicionIot> {
  final String id;

  /** Create an instance of MedicionIotModelIdentifier using [id] the primary key. */
  const MedicionIotModelIdentifier({
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
  String toString() => 'MedicionIotModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MedicionIotModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}