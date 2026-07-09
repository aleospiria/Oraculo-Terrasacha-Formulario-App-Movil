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


/** This is an auto generated class representing the ConsultaAnalisis type in your schema. */
class ConsultaAnalisis extends amplify_core.Model {
  static const classType = const _ConsultaAnalisisModelType();
  final String id;
  final String? _consultaNombre;
  final String? _consultaUbicacion;
  final String? _consultaParametros;
  final String? _consultaExternaPoligonos;
  final String? _consultaIdExterna;
  final String? _respuestaResultado;
  final String? _respuestaIdentificadorExterno;
  final String? _modeloId;
  final String? _modeloName;
  final String? _modeloDescription;
  final String? _modeloVersion;
  final String? _modeloDocumentLink;
  final String? _modeloApiLink;
  final String? _blockchainHashTransaccion;
  final amplify_core.TemporalDateTime? _fechaCreacion;
  final SourceType? _source;
  final Proyecto? _proyecto;
  final List<ConsultaEstado>? _estados;
  final List<AnalisisCuotasUsoDiario>? _cuotasUso;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ConsultaAnalisisModelIdentifier get modelIdentifier {
      return ConsultaAnalisisModelIdentifier(
        id: id
      );
  }
  
  String get consultaNombre {
    try {
      return _consultaNombre!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get consultaUbicacion {
    try {
      return _consultaUbicacion!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get consultaParametros {
    return _consultaParametros;
  }
  
  String? get consultaExternaPoligonos {
    return _consultaExternaPoligonos;
  }
  
  String? get consultaIdExterna {
    return _consultaIdExterna;
  }
  
  String? get respuestaResultado {
    return _respuestaResultado;
  }
  
  String? get respuestaIdentificadorExterno {
    return _respuestaIdentificadorExterno;
  }
  
  String? get modeloId {
    return _modeloId;
  }
  
  String? get modeloName {
    return _modeloName;
  }
  
  String? get modeloDescription {
    return _modeloDescription;
  }
  
  String? get modeloVersion {
    return _modeloVersion;
  }
  
  String? get modeloDocumentLink {
    return _modeloDocumentLink;
  }
  
  String? get modeloApiLink {
    return _modeloApiLink;
  }
  
  String? get blockchainHashTransaccion {
    return _blockchainHashTransaccion;
  }
  
  amplify_core.TemporalDateTime? get fechaCreacion {
    return _fechaCreacion;
  }
  
  SourceType get source {
    try {
      return _source!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  Proyecto? get proyecto {
    return _proyecto;
  }
  
  List<ConsultaEstado>? get estados {
    return _estados;
  }
  
  List<AnalisisCuotasUsoDiario>? get cuotasUso {
    return _cuotasUso;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ConsultaAnalisis._internal({required this.id, required consultaNombre, required consultaUbicacion, consultaParametros, consultaExternaPoligonos, consultaIdExterna, respuestaResultado, respuestaIdentificadorExterno, modeloId, modeloName, modeloDescription, modeloVersion, modeloDocumentLink, modeloApiLink, blockchainHashTransaccion, fechaCreacion, required source, proyecto, estados, cuotasUso, createdAt, updatedAt}): _consultaNombre = consultaNombre, _consultaUbicacion = consultaUbicacion, _consultaParametros = consultaParametros, _consultaExternaPoligonos = consultaExternaPoligonos, _consultaIdExterna = consultaIdExterna, _respuestaResultado = respuestaResultado, _respuestaIdentificadorExterno = respuestaIdentificadorExterno, _modeloId = modeloId, _modeloName = modeloName, _modeloDescription = modeloDescription, _modeloVersion = modeloVersion, _modeloDocumentLink = modeloDocumentLink, _modeloApiLink = modeloApiLink, _blockchainHashTransaccion = blockchainHashTransaccion, _fechaCreacion = fechaCreacion, _source = source, _proyecto = proyecto, _estados = estados, _cuotasUso = cuotasUso, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ConsultaAnalisis({String? id, required String consultaNombre, required String consultaUbicacion, String? consultaParametros, String? consultaExternaPoligonos, String? consultaIdExterna, String? respuestaResultado, String? respuestaIdentificadorExterno, String? modeloId, String? modeloName, String? modeloDescription, String? modeloVersion, String? modeloDocumentLink, String? modeloApiLink, String? blockchainHashTransaccion, amplify_core.TemporalDateTime? fechaCreacion, required SourceType source, Proyecto? proyecto, List<ConsultaEstado>? estados, List<AnalisisCuotasUsoDiario>? cuotasUso}) {
    return ConsultaAnalisis._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      consultaNombre: consultaNombre,
      consultaUbicacion: consultaUbicacion,
      consultaParametros: consultaParametros,
      consultaExternaPoligonos: consultaExternaPoligonos,
      consultaIdExterna: consultaIdExterna,
      respuestaResultado: respuestaResultado,
      respuestaIdentificadorExterno: respuestaIdentificadorExterno,
      modeloId: modeloId,
      modeloName: modeloName,
      modeloDescription: modeloDescription,
      modeloVersion: modeloVersion,
      modeloDocumentLink: modeloDocumentLink,
      modeloApiLink: modeloApiLink,
      blockchainHashTransaccion: blockchainHashTransaccion,
      fechaCreacion: fechaCreacion,
      source: source,
      proyecto: proyecto,
      estados: estados != null ? List<ConsultaEstado>.unmodifiable(estados) : estados,
      cuotasUso: cuotasUso != null ? List<AnalisisCuotasUsoDiario>.unmodifiable(cuotasUso) : cuotasUso);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConsultaAnalisis &&
      id == other.id &&
      _consultaNombre == other._consultaNombre &&
      _consultaUbicacion == other._consultaUbicacion &&
      _consultaParametros == other._consultaParametros &&
      _consultaExternaPoligonos == other._consultaExternaPoligonos &&
      _consultaIdExterna == other._consultaIdExterna &&
      _respuestaResultado == other._respuestaResultado &&
      _respuestaIdentificadorExterno == other._respuestaIdentificadorExterno &&
      _modeloId == other._modeloId &&
      _modeloName == other._modeloName &&
      _modeloDescription == other._modeloDescription &&
      _modeloVersion == other._modeloVersion &&
      _modeloDocumentLink == other._modeloDocumentLink &&
      _modeloApiLink == other._modeloApiLink &&
      _blockchainHashTransaccion == other._blockchainHashTransaccion &&
      _fechaCreacion == other._fechaCreacion &&
      _source == other._source &&
      _proyecto == other._proyecto &&
      DeepCollectionEquality().equals(_estados, other._estados) &&
      DeepCollectionEquality().equals(_cuotasUso, other._cuotasUso);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ConsultaAnalisis {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("consultaNombre=" + "$_consultaNombre" + ", ");
    buffer.write("consultaUbicacion=" + "$_consultaUbicacion" + ", ");
    buffer.write("consultaParametros=" + "$_consultaParametros" + ", ");
    buffer.write("consultaExternaPoligonos=" + "$_consultaExternaPoligonos" + ", ");
    buffer.write("consultaIdExterna=" + "$_consultaIdExterna" + ", ");
    buffer.write("respuestaResultado=" + "$_respuestaResultado" + ", ");
    buffer.write("respuestaIdentificadorExterno=" + "$_respuestaIdentificadorExterno" + ", ");
    buffer.write("modeloId=" + "$_modeloId" + ", ");
    buffer.write("modeloName=" + "$_modeloName" + ", ");
    buffer.write("modeloDescription=" + "$_modeloDescription" + ", ");
    buffer.write("modeloVersion=" + "$_modeloVersion" + ", ");
    buffer.write("modeloDocumentLink=" + "$_modeloDocumentLink" + ", ");
    buffer.write("modeloApiLink=" + "$_modeloApiLink" + ", ");
    buffer.write("blockchainHashTransaccion=" + "$_blockchainHashTransaccion" + ", ");
    buffer.write("fechaCreacion=" + (_fechaCreacion != null ? _fechaCreacion!.format() : "null") + ", ");
    buffer.write("source=" + (_source != null ? amplify_core.enumToString(_source)! : "null") + ", ");
    buffer.write("proyecto=" + (_proyecto != null ? _proyecto!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ConsultaAnalisis copyWith({String? consultaNombre, String? consultaUbicacion, String? consultaParametros, String? consultaExternaPoligonos, String? consultaIdExterna, String? respuestaResultado, String? respuestaIdentificadorExterno, String? modeloId, String? modeloName, String? modeloDescription, String? modeloVersion, String? modeloDocumentLink, String? modeloApiLink, String? blockchainHashTransaccion, amplify_core.TemporalDateTime? fechaCreacion, SourceType? source, Proyecto? proyecto, List<ConsultaEstado>? estados, List<AnalisisCuotasUsoDiario>? cuotasUso}) {
    return ConsultaAnalisis._internal(
      id: id,
      consultaNombre: consultaNombre ?? this.consultaNombre,
      consultaUbicacion: consultaUbicacion ?? this.consultaUbicacion,
      consultaParametros: consultaParametros ?? this.consultaParametros,
      consultaExternaPoligonos: consultaExternaPoligonos ?? this.consultaExternaPoligonos,
      consultaIdExterna: consultaIdExterna ?? this.consultaIdExterna,
      respuestaResultado: respuestaResultado ?? this.respuestaResultado,
      respuestaIdentificadorExterno: respuestaIdentificadorExterno ?? this.respuestaIdentificadorExterno,
      modeloId: modeloId ?? this.modeloId,
      modeloName: modeloName ?? this.modeloName,
      modeloDescription: modeloDescription ?? this.modeloDescription,
      modeloVersion: modeloVersion ?? this.modeloVersion,
      modeloDocumentLink: modeloDocumentLink ?? this.modeloDocumentLink,
      modeloApiLink: modeloApiLink ?? this.modeloApiLink,
      blockchainHashTransaccion: blockchainHashTransaccion ?? this.blockchainHashTransaccion,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      source: source ?? this.source,
      proyecto: proyecto ?? this.proyecto,
      estados: estados ?? this.estados,
      cuotasUso: cuotasUso ?? this.cuotasUso);
  }
  
  ConsultaAnalisis copyWithModelFieldValues({
    ModelFieldValue<String>? consultaNombre,
    ModelFieldValue<String>? consultaUbicacion,
    ModelFieldValue<String?>? consultaParametros,
    ModelFieldValue<String?>? consultaExternaPoligonos,
    ModelFieldValue<String?>? consultaIdExterna,
    ModelFieldValue<String?>? respuestaResultado,
    ModelFieldValue<String?>? respuestaIdentificadorExterno,
    ModelFieldValue<String?>? modeloId,
    ModelFieldValue<String?>? modeloName,
    ModelFieldValue<String?>? modeloDescription,
    ModelFieldValue<String?>? modeloVersion,
    ModelFieldValue<String?>? modeloDocumentLink,
    ModelFieldValue<String?>? modeloApiLink,
    ModelFieldValue<String?>? blockchainHashTransaccion,
    ModelFieldValue<amplify_core.TemporalDateTime?>? fechaCreacion,
    ModelFieldValue<SourceType>? source,
    ModelFieldValue<Proyecto?>? proyecto,
    ModelFieldValue<List<ConsultaEstado>?>? estados,
    ModelFieldValue<List<AnalisisCuotasUsoDiario>?>? cuotasUso
  }) {
    return ConsultaAnalisis._internal(
      id: id,
      consultaNombre: consultaNombre == null ? this.consultaNombre : consultaNombre.value,
      consultaUbicacion: consultaUbicacion == null ? this.consultaUbicacion : consultaUbicacion.value,
      consultaParametros: consultaParametros == null ? this.consultaParametros : consultaParametros.value,
      consultaExternaPoligonos: consultaExternaPoligonos == null ? this.consultaExternaPoligonos : consultaExternaPoligonos.value,
      consultaIdExterna: consultaIdExterna == null ? this.consultaIdExterna : consultaIdExterna.value,
      respuestaResultado: respuestaResultado == null ? this.respuestaResultado : respuestaResultado.value,
      respuestaIdentificadorExterno: respuestaIdentificadorExterno == null ? this.respuestaIdentificadorExterno : respuestaIdentificadorExterno.value,
      modeloId: modeloId == null ? this.modeloId : modeloId.value,
      modeloName: modeloName == null ? this.modeloName : modeloName.value,
      modeloDescription: modeloDescription == null ? this.modeloDescription : modeloDescription.value,
      modeloVersion: modeloVersion == null ? this.modeloVersion : modeloVersion.value,
      modeloDocumentLink: modeloDocumentLink == null ? this.modeloDocumentLink : modeloDocumentLink.value,
      modeloApiLink: modeloApiLink == null ? this.modeloApiLink : modeloApiLink.value,
      blockchainHashTransaccion: blockchainHashTransaccion == null ? this.blockchainHashTransaccion : blockchainHashTransaccion.value,
      fechaCreacion: fechaCreacion == null ? this.fechaCreacion : fechaCreacion.value,
      source: source == null ? this.source : source.value,
      proyecto: proyecto == null ? this.proyecto : proyecto.value,
      estados: estados == null ? this.estados : estados.value,
      cuotasUso: cuotasUso == null ? this.cuotasUso : cuotasUso.value
    );
  }
  
  ConsultaAnalisis.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _consultaNombre = json['consultaNombre'],
      _consultaUbicacion = json['consultaUbicacion'],
      _consultaParametros = json['consultaParametros'],
      _consultaExternaPoligonos = json['consultaExternaPoligonos'],
      _consultaIdExterna = json['consultaIdExterna'],
      _respuestaResultado = json['respuestaResultado'],
      _respuestaIdentificadorExterno = json['respuestaIdentificadorExterno'],
      _modeloId = json['modeloId'],
      _modeloName = json['modeloName'],
      _modeloDescription = json['modeloDescription'],
      _modeloVersion = json['modeloVersion'],
      _modeloDocumentLink = json['modeloDocumentLink'],
      _modeloApiLink = json['modeloApiLink'],
      _blockchainHashTransaccion = json['blockchainHashTransaccion'],
      _fechaCreacion = json['fechaCreacion'] != null ? amplify_core.TemporalDateTime.fromString(json['fechaCreacion']) : null,
      _source = amplify_core.enumFromString<SourceType>(json['source'], SourceType.values),
      _proyecto = json['proyecto'] != null
        ? json['proyecto']['serializedData'] != null
          ? Proyecto.fromJson(new Map<String, dynamic>.from(json['proyecto']['serializedData']))
          : Proyecto.fromJson(new Map<String, dynamic>.from(json['proyecto']))
        : null,
      _estados = json['estados']  is Map
        ? (json['estados']['items'] is List
          ? (json['estados']['items'] as List)
              .where((e) => e != null)
              .map((e) => ConsultaEstado.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['estados'] is List
          ? (json['estados'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ConsultaEstado.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _cuotasUso = json['cuotasUso']  is Map
        ? (json['cuotasUso']['items'] is List
          ? (json['cuotasUso']['items'] as List)
              .where((e) => e != null)
              .map((e) => AnalisisCuotasUsoDiario.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['cuotasUso'] is List
          ? (json['cuotasUso'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => AnalisisCuotasUsoDiario.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'consultaNombre': _consultaNombre, 'consultaUbicacion': _consultaUbicacion, 'consultaParametros': _consultaParametros, 'consultaExternaPoligonos': _consultaExternaPoligonos, 'consultaIdExterna': _consultaIdExterna, 'respuestaResultado': _respuestaResultado, 'respuestaIdentificadorExterno': _respuestaIdentificadorExterno, 'modeloId': _modeloId, 'modeloName': _modeloName, 'modeloDescription': _modeloDescription, 'modeloVersion': _modeloVersion, 'modeloDocumentLink': _modeloDocumentLink, 'modeloApiLink': _modeloApiLink, 'blockchainHashTransaccion': _blockchainHashTransaccion, 'fechaCreacion': _fechaCreacion?.format(), 'source': amplify_core.enumToString(_source), 'proyecto': _proyecto?.toJson(), 'estados': _estados?.map((ConsultaEstado? e) => e?.toJson()).toList(), 'cuotasUso': _cuotasUso?.map((AnalisisCuotasUsoDiario? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'consultaNombre': _consultaNombre,
    'consultaUbicacion': _consultaUbicacion,
    'consultaParametros': _consultaParametros,
    'consultaExternaPoligonos': _consultaExternaPoligonos,
    'consultaIdExterna': _consultaIdExterna,
    'respuestaResultado': _respuestaResultado,
    'respuestaIdentificadorExterno': _respuestaIdentificadorExterno,
    'modeloId': _modeloId,
    'modeloName': _modeloName,
    'modeloDescription': _modeloDescription,
    'modeloVersion': _modeloVersion,
    'modeloDocumentLink': _modeloDocumentLink,
    'modeloApiLink': _modeloApiLink,
    'blockchainHashTransaccion': _blockchainHashTransaccion,
    'fechaCreacion': _fechaCreacion,
    'source': _source,
    'proyecto': _proyecto,
    'estados': _estados,
    'cuotasUso': _cuotasUso,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ConsultaAnalisisModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ConsultaAnalisisModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final CONSULTANOMBRE = amplify_core.QueryField(fieldName: "consultaNombre");
  static final CONSULTAUBICACION = amplify_core.QueryField(fieldName: "consultaUbicacion");
  static final CONSULTAPARAMETROS = amplify_core.QueryField(fieldName: "consultaParametros");
  static final CONSULTAEXTERNAPOLIGONOS = amplify_core.QueryField(fieldName: "consultaExternaPoligonos");
  static final CONSULTAIDEXTERNA = amplify_core.QueryField(fieldName: "consultaIdExterna");
  static final RESPUESTARESULTADO = amplify_core.QueryField(fieldName: "respuestaResultado");
  static final RESPUESTAIDENTIFICADOREXTERNO = amplify_core.QueryField(fieldName: "respuestaIdentificadorExterno");
  static final MODELOID = amplify_core.QueryField(fieldName: "modeloId");
  static final MODELONAME = amplify_core.QueryField(fieldName: "modeloName");
  static final MODELODESCRIPTION = amplify_core.QueryField(fieldName: "modeloDescription");
  static final MODELOVERSION = amplify_core.QueryField(fieldName: "modeloVersion");
  static final MODELODOCUMENTLINK = amplify_core.QueryField(fieldName: "modeloDocumentLink");
  static final MODELOAPILINK = amplify_core.QueryField(fieldName: "modeloApiLink");
  static final BLOCKCHAINHASHTRANSACCION = amplify_core.QueryField(fieldName: "blockchainHashTransaccion");
  static final FECHACREACION = amplify_core.QueryField(fieldName: "fechaCreacion");
  static final SOURCE = amplify_core.QueryField(fieldName: "source");
  static final PROYECTO = amplify_core.QueryField(
    fieldName: "proyecto",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Proyecto'));
  static final ESTADOS = amplify_core.QueryField(
    fieldName: "estados",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ConsultaEstado'));
  static final CUOTASUSO = amplify_core.QueryField(
    fieldName: "cuotasUso",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'AnalisisCuotasUsoDiario'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ConsultaAnalisis";
    modelSchemaDefinition.pluralName = "ConsultaAnalises";
    
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
      amplify_core.ModelIndex(fields: const ["proyectoId"], name: "byProyecto")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.CONSULTANOMBRE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.CONSULTAUBICACION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.CONSULTAPARAMETROS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.CONSULTAEXTERNAPOLIGONOS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.CONSULTAIDEXTERNA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.RESPUESTARESULTADO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.RESPUESTAIDENTIFICADOREXTERNO,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.MODELOID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.MODELONAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.MODELODESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.MODELOVERSION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.MODELODOCUMENTLINK,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.MODELOAPILINK,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.BLOCKCHAINHASHTRANSACCION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.FECHACREACION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaAnalisis.SOURCE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ConsultaAnalisis.PROYECTO,
      isRequired: false,
      targetNames: ['proyectoId'],
      ofModelName: 'Proyecto'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ConsultaAnalisis.ESTADOS,
      isRequired: false,
      ofModelName: 'ConsultaEstado',
      associatedKey: ConsultaEstado.CONSULTA
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ConsultaAnalisis.CUOTASUSO,
      isRequired: false,
      ofModelName: 'AnalisisCuotasUsoDiario',
      associatedKey: AnalisisCuotasUsoDiario.CONSULTA
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

class _ConsultaAnalisisModelType extends amplify_core.ModelType<ConsultaAnalisis> {
  const _ConsultaAnalisisModelType();
  
  @override
  ConsultaAnalisis fromJson(Map<String, dynamic> jsonData) {
    return ConsultaAnalisis.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ConsultaAnalisis';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ConsultaAnalisis] in your schema.
 */
class ConsultaAnalisisModelIdentifier implements amplify_core.ModelIdentifier<ConsultaAnalisis> {
  final String id;

  /** Create an instance of ConsultaAnalisisModelIdentifier using [id] the primary key. */
  const ConsultaAnalisisModelIdentifier({
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
  String toString() => 'ConsultaAnalisisModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ConsultaAnalisisModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}