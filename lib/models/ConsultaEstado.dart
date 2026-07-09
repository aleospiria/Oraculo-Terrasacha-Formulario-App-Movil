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


/** This is an auto generated class representing the ConsultaEstado type in your schema. */
class ConsultaEstado extends amplify_core.Model {
  static const classType = const _ConsultaEstadoModelType();
  final String id;
  final EstadoConsulta? _estado;
  final amplify_core.TemporalDateTime? _estadoFecha;
  final String? _estadoUsername;
  final String? _estadoObservaciones;
  final EstadoTipoActor? _estadoTipoActor;
  final ConsultaAnalisis? _consulta;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ConsultaEstadoModelIdentifier get modelIdentifier {
      return ConsultaEstadoModelIdentifier(
        id: id
      );
  }
  
  EstadoConsulta get estado {
    try {
      return _estado!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get estadoFecha {
    try {
      return _estadoFecha!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get estadoUsername {
    return _estadoUsername;
  }
  
  String? get estadoObservaciones {
    return _estadoObservaciones;
  }
  
  EstadoTipoActor get estadoTipoActor {
    try {
      return _estadoTipoActor!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  ConsultaAnalisis? get consulta {
    return _consulta;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ConsultaEstado._internal({required this.id, required estado, required estadoFecha, estadoUsername, estadoObservaciones, required estadoTipoActor, consulta, createdAt, updatedAt}): _estado = estado, _estadoFecha = estadoFecha, _estadoUsername = estadoUsername, _estadoObservaciones = estadoObservaciones, _estadoTipoActor = estadoTipoActor, _consulta = consulta, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ConsultaEstado({String? id, required EstadoConsulta estado, required amplify_core.TemporalDateTime estadoFecha, String? estadoUsername, String? estadoObservaciones, required EstadoTipoActor estadoTipoActor, ConsultaAnalisis? consulta}) {
    return ConsultaEstado._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      estado: estado,
      estadoFecha: estadoFecha,
      estadoUsername: estadoUsername,
      estadoObservaciones: estadoObservaciones,
      estadoTipoActor: estadoTipoActor,
      consulta: consulta);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConsultaEstado &&
      id == other.id &&
      _estado == other._estado &&
      _estadoFecha == other._estadoFecha &&
      _estadoUsername == other._estadoUsername &&
      _estadoObservaciones == other._estadoObservaciones &&
      _estadoTipoActor == other._estadoTipoActor &&
      _consulta == other._consulta;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ConsultaEstado {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("estado=" + (_estado != null ? amplify_core.enumToString(_estado)! : "null") + ", ");
    buffer.write("estadoFecha=" + (_estadoFecha != null ? _estadoFecha!.format() : "null") + ", ");
    buffer.write("estadoUsername=" + "$_estadoUsername" + ", ");
    buffer.write("estadoObservaciones=" + "$_estadoObservaciones" + ", ");
    buffer.write("estadoTipoActor=" + (_estadoTipoActor != null ? amplify_core.enumToString(_estadoTipoActor)! : "null") + ", ");
    buffer.write("consulta=" + (_consulta != null ? _consulta!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ConsultaEstado copyWith({EstadoConsulta? estado, amplify_core.TemporalDateTime? estadoFecha, String? estadoUsername, String? estadoObservaciones, EstadoTipoActor? estadoTipoActor, ConsultaAnalisis? consulta}) {
    return ConsultaEstado._internal(
      id: id,
      estado: estado ?? this.estado,
      estadoFecha: estadoFecha ?? this.estadoFecha,
      estadoUsername: estadoUsername ?? this.estadoUsername,
      estadoObservaciones: estadoObservaciones ?? this.estadoObservaciones,
      estadoTipoActor: estadoTipoActor ?? this.estadoTipoActor,
      consulta: consulta ?? this.consulta);
  }
  
  ConsultaEstado copyWithModelFieldValues({
    ModelFieldValue<EstadoConsulta>? estado,
    ModelFieldValue<amplify_core.TemporalDateTime>? estadoFecha,
    ModelFieldValue<String?>? estadoUsername,
    ModelFieldValue<String?>? estadoObservaciones,
    ModelFieldValue<EstadoTipoActor>? estadoTipoActor,
    ModelFieldValue<ConsultaAnalisis?>? consulta
  }) {
    return ConsultaEstado._internal(
      id: id,
      estado: estado == null ? this.estado : estado.value,
      estadoFecha: estadoFecha == null ? this.estadoFecha : estadoFecha.value,
      estadoUsername: estadoUsername == null ? this.estadoUsername : estadoUsername.value,
      estadoObservaciones: estadoObservaciones == null ? this.estadoObservaciones : estadoObservaciones.value,
      estadoTipoActor: estadoTipoActor == null ? this.estadoTipoActor : estadoTipoActor.value,
      consulta: consulta == null ? this.consulta : consulta.value
    );
  }
  
  ConsultaEstado.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _estado = amplify_core.enumFromString<EstadoConsulta>(json['estado'], EstadoConsulta.values),
      _estadoFecha = json['estadoFecha'] != null ? amplify_core.TemporalDateTime.fromString(json['estadoFecha']) : null,
      _estadoUsername = json['estadoUsername'],
      _estadoObservaciones = json['estadoObservaciones'],
      _estadoTipoActor = amplify_core.enumFromString<EstadoTipoActor>(json['estadoTipoActor'], EstadoTipoActor.values),
      _consulta = json['consulta'] != null
        ? json['consulta']['serializedData'] != null
          ? ConsultaAnalisis.fromJson(new Map<String, dynamic>.from(json['consulta']['serializedData']))
          : ConsultaAnalisis.fromJson(new Map<String, dynamic>.from(json['consulta']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'estado': amplify_core.enumToString(_estado), 'estadoFecha': _estadoFecha?.format(), 'estadoUsername': _estadoUsername, 'estadoObservaciones': _estadoObservaciones, 'estadoTipoActor': amplify_core.enumToString(_estadoTipoActor), 'consulta': _consulta?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'estado': _estado,
    'estadoFecha': _estadoFecha,
    'estadoUsername': _estadoUsername,
    'estadoObservaciones': _estadoObservaciones,
    'estadoTipoActor': _estadoTipoActor,
    'consulta': _consulta,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ConsultaEstadoModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ConsultaEstadoModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final ESTADO = amplify_core.QueryField(fieldName: "estado");
  static final ESTADOFECHA = amplify_core.QueryField(fieldName: "estadoFecha");
  static final ESTADOUSERNAME = amplify_core.QueryField(fieldName: "estadoUsername");
  static final ESTADOOBSERVACIONES = amplify_core.QueryField(fieldName: "estadoObservaciones");
  static final ESTADOTIPOACTOR = amplify_core.QueryField(fieldName: "estadoTipoActor");
  static final CONSULTA = amplify_core.QueryField(
    fieldName: "consulta",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConsultaAnalisis'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ConsultaEstado";
    modelSchemaDefinition.pluralName = "ConsultaEstados";
    
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
      amplify_core.ModelIndex(fields: const ["consultaId"], name: "byConsulta")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaEstado.ESTADO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaEstado.ESTADOFECHA,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaEstado.ESTADOUSERNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaEstado.ESTADOOBSERVACIONES,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaEstado.ESTADOTIPOACTOR,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ConsultaEstado.CONSULTA,
      isRequired: false,
      targetNames: ['consultaId'],
      ofModelName: 'ConsultaAnalisis'
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

class _ConsultaEstadoModelType extends amplify_core.ModelType<ConsultaEstado> {
  const _ConsultaEstadoModelType();
  
  @override
  ConsultaEstado fromJson(Map<String, dynamic> jsonData) {
    return ConsultaEstado.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ConsultaEstado';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ConsultaEstado] in your schema.
 */
class ConsultaEstadoModelIdentifier implements amplify_core.ModelIdentifier<ConsultaEstado> {
  final String id;

  /** Create an instance of ConsultaEstadoModelIdentifier using [id] the primary key. */
  const ConsultaEstadoModelIdentifier({
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
  String toString() => 'ConsultaEstadoModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ConsultaEstadoModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}