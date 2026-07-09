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


/** This is an auto generated class representing the ConsultaWeb type in your schema. */
class ConsultaWeb extends amplify_core.Model {
  static const classType = const _ConsultaWebModelType();
  final String id;
  final String? _imgAnteriorNombreImg;
  final String? _imgAnteriorSatellite;
  final int? _imgAnteriorYear;
  final int? _imgAnteriorMesInicial;
  final int? _imgAnteriorMesFinal;
  final int? _imgAnteriorNubosidadMaxima;
  final String? _imgAnteriorBandas;
  final String? _imgPosteriorNombreImg;
  final String? _imgPosteriorSatellite;
  final int? _imgPosteriorYear;
  final int? _imgPosteriorMesInicial;
  final int? _imgPosteriorMesFinal;
  final int? _imgPosteriorNubosidadMaxima;
  final String? _imgPosteriorBandas;
  final amplify_core.TemporalDateTime? _fechaHoraConsulta;
  final String? _usuarioEmailUpdate;
  final String? _rawConsulta;
  final String? _resultadoConsulta;
  final ProyectoLegacy? _proyecto;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ConsultaWebModelIdentifier get modelIdentifier {
      return ConsultaWebModelIdentifier(
        id: id
      );
  }
  
  String? get imgAnteriorNombreImg {
    return _imgAnteriorNombreImg;
  }
  
  String? get imgAnteriorSatellite {
    return _imgAnteriorSatellite;
  }
  
  int? get imgAnteriorYear {
    return _imgAnteriorYear;
  }
  
  int? get imgAnteriorMesInicial {
    return _imgAnteriorMesInicial;
  }
  
  int? get imgAnteriorMesFinal {
    return _imgAnteriorMesFinal;
  }
  
  int? get imgAnteriorNubosidadMaxima {
    return _imgAnteriorNubosidadMaxima;
  }
  
  String? get imgAnteriorBandas {
    return _imgAnteriorBandas;
  }
  
  String? get imgPosteriorNombreImg {
    return _imgPosteriorNombreImg;
  }
  
  String? get imgPosteriorSatellite {
    return _imgPosteriorSatellite;
  }
  
  int? get imgPosteriorYear {
    return _imgPosteriorYear;
  }
  
  int? get imgPosteriorMesInicial {
    return _imgPosteriorMesInicial;
  }
  
  int? get imgPosteriorMesFinal {
    return _imgPosteriorMesFinal;
  }
  
  int? get imgPosteriorNubosidadMaxima {
    return _imgPosteriorNubosidadMaxima;
  }
  
  String? get imgPosteriorBandas {
    return _imgPosteriorBandas;
  }
  
  amplify_core.TemporalDateTime? get fechaHoraConsulta {
    return _fechaHoraConsulta;
  }
  
  String? get usuarioEmailUpdate {
    return _usuarioEmailUpdate;
  }
  
  String? get rawConsulta {
    return _rawConsulta;
  }
  
  String? get resultadoConsulta {
    return _resultadoConsulta;
  }
  
  ProyectoLegacy? get proyecto {
    return _proyecto;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ConsultaWeb._internal({required this.id, imgAnteriorNombreImg, imgAnteriorSatellite, imgAnteriorYear, imgAnteriorMesInicial, imgAnteriorMesFinal, imgAnteriorNubosidadMaxima, imgAnteriorBandas, imgPosteriorNombreImg, imgPosteriorSatellite, imgPosteriorYear, imgPosteriorMesInicial, imgPosteriorMesFinal, imgPosteriorNubosidadMaxima, imgPosteriorBandas, fechaHoraConsulta, usuarioEmailUpdate, rawConsulta, resultadoConsulta, proyecto, createdAt, updatedAt}): _imgAnteriorNombreImg = imgAnteriorNombreImg, _imgAnteriorSatellite = imgAnteriorSatellite, _imgAnteriorYear = imgAnteriorYear, _imgAnteriorMesInicial = imgAnteriorMesInicial, _imgAnteriorMesFinal = imgAnteriorMesFinal, _imgAnteriorNubosidadMaxima = imgAnteriorNubosidadMaxima, _imgAnteriorBandas = imgAnteriorBandas, _imgPosteriorNombreImg = imgPosteriorNombreImg, _imgPosteriorSatellite = imgPosteriorSatellite, _imgPosteriorYear = imgPosteriorYear, _imgPosteriorMesInicial = imgPosteriorMesInicial, _imgPosteriorMesFinal = imgPosteriorMesFinal, _imgPosteriorNubosidadMaxima = imgPosteriorNubosidadMaxima, _imgPosteriorBandas = imgPosteriorBandas, _fechaHoraConsulta = fechaHoraConsulta, _usuarioEmailUpdate = usuarioEmailUpdate, _rawConsulta = rawConsulta, _resultadoConsulta = resultadoConsulta, _proyecto = proyecto, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ConsultaWeb({String? id, String? imgAnteriorNombreImg, String? imgAnteriorSatellite, int? imgAnteriorYear, int? imgAnteriorMesInicial, int? imgAnteriorMesFinal, int? imgAnteriorNubosidadMaxima, String? imgAnteriorBandas, String? imgPosteriorNombreImg, String? imgPosteriorSatellite, int? imgPosteriorYear, int? imgPosteriorMesInicial, int? imgPosteriorMesFinal, int? imgPosteriorNubosidadMaxima, String? imgPosteriorBandas, amplify_core.TemporalDateTime? fechaHoraConsulta, String? usuarioEmailUpdate, String? rawConsulta, String? resultadoConsulta, ProyectoLegacy? proyecto}) {
    return ConsultaWeb._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      imgAnteriorNombreImg: imgAnteriorNombreImg,
      imgAnteriorSatellite: imgAnteriorSatellite,
      imgAnteriorYear: imgAnteriorYear,
      imgAnteriorMesInicial: imgAnteriorMesInicial,
      imgAnteriorMesFinal: imgAnteriorMesFinal,
      imgAnteriorNubosidadMaxima: imgAnteriorNubosidadMaxima,
      imgAnteriorBandas: imgAnteriorBandas,
      imgPosteriorNombreImg: imgPosteriorNombreImg,
      imgPosteriorSatellite: imgPosteriorSatellite,
      imgPosteriorYear: imgPosteriorYear,
      imgPosteriorMesInicial: imgPosteriorMesInicial,
      imgPosteriorMesFinal: imgPosteriorMesFinal,
      imgPosteriorNubosidadMaxima: imgPosteriorNubosidadMaxima,
      imgPosteriorBandas: imgPosteriorBandas,
      fechaHoraConsulta: fechaHoraConsulta,
      usuarioEmailUpdate: usuarioEmailUpdate,
      rawConsulta: rawConsulta,
      resultadoConsulta: resultadoConsulta,
      proyecto: proyecto);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConsultaWeb &&
      id == other.id &&
      _imgAnteriorNombreImg == other._imgAnteriorNombreImg &&
      _imgAnteriorSatellite == other._imgAnteriorSatellite &&
      _imgAnteriorYear == other._imgAnteriorYear &&
      _imgAnteriorMesInicial == other._imgAnteriorMesInicial &&
      _imgAnteriorMesFinal == other._imgAnteriorMesFinal &&
      _imgAnteriorNubosidadMaxima == other._imgAnteriorNubosidadMaxima &&
      _imgAnteriorBandas == other._imgAnteriorBandas &&
      _imgPosteriorNombreImg == other._imgPosteriorNombreImg &&
      _imgPosteriorSatellite == other._imgPosteriorSatellite &&
      _imgPosteriorYear == other._imgPosteriorYear &&
      _imgPosteriorMesInicial == other._imgPosteriorMesInicial &&
      _imgPosteriorMesFinal == other._imgPosteriorMesFinal &&
      _imgPosteriorNubosidadMaxima == other._imgPosteriorNubosidadMaxima &&
      _imgPosteriorBandas == other._imgPosteriorBandas &&
      _fechaHoraConsulta == other._fechaHoraConsulta &&
      _usuarioEmailUpdate == other._usuarioEmailUpdate &&
      _rawConsulta == other._rawConsulta &&
      _resultadoConsulta == other._resultadoConsulta &&
      _proyecto == other._proyecto;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ConsultaWeb {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("imgAnteriorNombreImg=" + "$_imgAnteriorNombreImg" + ", ");
    buffer.write("imgAnteriorSatellite=" + "$_imgAnteriorSatellite" + ", ");
    buffer.write("imgAnteriorYear=" + (_imgAnteriorYear != null ? _imgAnteriorYear!.toString() : "null") + ", ");
    buffer.write("imgAnteriorMesInicial=" + (_imgAnteriorMesInicial != null ? _imgAnteriorMesInicial!.toString() : "null") + ", ");
    buffer.write("imgAnteriorMesFinal=" + (_imgAnteriorMesFinal != null ? _imgAnteriorMesFinal!.toString() : "null") + ", ");
    buffer.write("imgAnteriorNubosidadMaxima=" + (_imgAnteriorNubosidadMaxima != null ? _imgAnteriorNubosidadMaxima!.toString() : "null") + ", ");
    buffer.write("imgAnteriorBandas=" + "$_imgAnteriorBandas" + ", ");
    buffer.write("imgPosteriorNombreImg=" + "$_imgPosteriorNombreImg" + ", ");
    buffer.write("imgPosteriorSatellite=" + "$_imgPosteriorSatellite" + ", ");
    buffer.write("imgPosteriorYear=" + (_imgPosteriorYear != null ? _imgPosteriorYear!.toString() : "null") + ", ");
    buffer.write("imgPosteriorMesInicial=" + (_imgPosteriorMesInicial != null ? _imgPosteriorMesInicial!.toString() : "null") + ", ");
    buffer.write("imgPosteriorMesFinal=" + (_imgPosteriorMesFinal != null ? _imgPosteriorMesFinal!.toString() : "null") + ", ");
    buffer.write("imgPosteriorNubosidadMaxima=" + (_imgPosteriorNubosidadMaxima != null ? _imgPosteriorNubosidadMaxima!.toString() : "null") + ", ");
    buffer.write("imgPosteriorBandas=" + "$_imgPosteriorBandas" + ", ");
    buffer.write("fechaHoraConsulta=" + (_fechaHoraConsulta != null ? _fechaHoraConsulta!.format() : "null") + ", ");
    buffer.write("usuarioEmailUpdate=" + "$_usuarioEmailUpdate" + ", ");
    buffer.write("rawConsulta=" + "$_rawConsulta" + ", ");
    buffer.write("resultadoConsulta=" + "$_resultadoConsulta" + ", ");
    buffer.write("proyecto=" + (_proyecto != null ? _proyecto!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ConsultaWeb copyWith({String? imgAnteriorNombreImg, String? imgAnteriorSatellite, int? imgAnteriorYear, int? imgAnteriorMesInicial, int? imgAnteriorMesFinal, int? imgAnteriorNubosidadMaxima, String? imgAnteriorBandas, String? imgPosteriorNombreImg, String? imgPosteriorSatellite, int? imgPosteriorYear, int? imgPosteriorMesInicial, int? imgPosteriorMesFinal, int? imgPosteriorNubosidadMaxima, String? imgPosteriorBandas, amplify_core.TemporalDateTime? fechaHoraConsulta, String? usuarioEmailUpdate, String? rawConsulta, String? resultadoConsulta, ProyectoLegacy? proyecto}) {
    return ConsultaWeb._internal(
      id: id,
      imgAnteriorNombreImg: imgAnteriorNombreImg ?? this.imgAnteriorNombreImg,
      imgAnteriorSatellite: imgAnteriorSatellite ?? this.imgAnteriorSatellite,
      imgAnteriorYear: imgAnteriorYear ?? this.imgAnteriorYear,
      imgAnteriorMesInicial: imgAnteriorMesInicial ?? this.imgAnteriorMesInicial,
      imgAnteriorMesFinal: imgAnteriorMesFinal ?? this.imgAnteriorMesFinal,
      imgAnteriorNubosidadMaxima: imgAnteriorNubosidadMaxima ?? this.imgAnteriorNubosidadMaxima,
      imgAnteriorBandas: imgAnteriorBandas ?? this.imgAnteriorBandas,
      imgPosteriorNombreImg: imgPosteriorNombreImg ?? this.imgPosteriorNombreImg,
      imgPosteriorSatellite: imgPosteriorSatellite ?? this.imgPosteriorSatellite,
      imgPosteriorYear: imgPosteriorYear ?? this.imgPosteriorYear,
      imgPosteriorMesInicial: imgPosteriorMesInicial ?? this.imgPosteriorMesInicial,
      imgPosteriorMesFinal: imgPosteriorMesFinal ?? this.imgPosteriorMesFinal,
      imgPosteriorNubosidadMaxima: imgPosteriorNubosidadMaxima ?? this.imgPosteriorNubosidadMaxima,
      imgPosteriorBandas: imgPosteriorBandas ?? this.imgPosteriorBandas,
      fechaHoraConsulta: fechaHoraConsulta ?? this.fechaHoraConsulta,
      usuarioEmailUpdate: usuarioEmailUpdate ?? this.usuarioEmailUpdate,
      rawConsulta: rawConsulta ?? this.rawConsulta,
      resultadoConsulta: resultadoConsulta ?? this.resultadoConsulta,
      proyecto: proyecto ?? this.proyecto);
  }
  
  ConsultaWeb copyWithModelFieldValues({
    ModelFieldValue<String?>? imgAnteriorNombreImg,
    ModelFieldValue<String?>? imgAnteriorSatellite,
    ModelFieldValue<int?>? imgAnteriorYear,
    ModelFieldValue<int?>? imgAnteriorMesInicial,
    ModelFieldValue<int?>? imgAnteriorMesFinal,
    ModelFieldValue<int?>? imgAnteriorNubosidadMaxima,
    ModelFieldValue<String?>? imgAnteriorBandas,
    ModelFieldValue<String?>? imgPosteriorNombreImg,
    ModelFieldValue<String?>? imgPosteriorSatellite,
    ModelFieldValue<int?>? imgPosteriorYear,
    ModelFieldValue<int?>? imgPosteriorMesInicial,
    ModelFieldValue<int?>? imgPosteriorMesFinal,
    ModelFieldValue<int?>? imgPosteriorNubosidadMaxima,
    ModelFieldValue<String?>? imgPosteriorBandas,
    ModelFieldValue<amplify_core.TemporalDateTime?>? fechaHoraConsulta,
    ModelFieldValue<String?>? usuarioEmailUpdate,
    ModelFieldValue<String?>? rawConsulta,
    ModelFieldValue<String?>? resultadoConsulta,
    ModelFieldValue<ProyectoLegacy?>? proyecto
  }) {
    return ConsultaWeb._internal(
      id: id,
      imgAnteriorNombreImg: imgAnteriorNombreImg == null ? this.imgAnteriorNombreImg : imgAnteriorNombreImg.value,
      imgAnteriorSatellite: imgAnteriorSatellite == null ? this.imgAnteriorSatellite : imgAnteriorSatellite.value,
      imgAnteriorYear: imgAnteriorYear == null ? this.imgAnteriorYear : imgAnteriorYear.value,
      imgAnteriorMesInicial: imgAnteriorMesInicial == null ? this.imgAnteriorMesInicial : imgAnteriorMesInicial.value,
      imgAnteriorMesFinal: imgAnteriorMesFinal == null ? this.imgAnteriorMesFinal : imgAnteriorMesFinal.value,
      imgAnteriorNubosidadMaxima: imgAnteriorNubosidadMaxima == null ? this.imgAnteriorNubosidadMaxima : imgAnteriorNubosidadMaxima.value,
      imgAnteriorBandas: imgAnteriorBandas == null ? this.imgAnteriorBandas : imgAnteriorBandas.value,
      imgPosteriorNombreImg: imgPosteriorNombreImg == null ? this.imgPosteriorNombreImg : imgPosteriorNombreImg.value,
      imgPosteriorSatellite: imgPosteriorSatellite == null ? this.imgPosteriorSatellite : imgPosteriorSatellite.value,
      imgPosteriorYear: imgPosteriorYear == null ? this.imgPosteriorYear : imgPosteriorYear.value,
      imgPosteriorMesInicial: imgPosteriorMesInicial == null ? this.imgPosteriorMesInicial : imgPosteriorMesInicial.value,
      imgPosteriorMesFinal: imgPosteriorMesFinal == null ? this.imgPosteriorMesFinal : imgPosteriorMesFinal.value,
      imgPosteriorNubosidadMaxima: imgPosteriorNubosidadMaxima == null ? this.imgPosteriorNubosidadMaxima : imgPosteriorNubosidadMaxima.value,
      imgPosteriorBandas: imgPosteriorBandas == null ? this.imgPosteriorBandas : imgPosteriorBandas.value,
      fechaHoraConsulta: fechaHoraConsulta == null ? this.fechaHoraConsulta : fechaHoraConsulta.value,
      usuarioEmailUpdate: usuarioEmailUpdate == null ? this.usuarioEmailUpdate : usuarioEmailUpdate.value,
      rawConsulta: rawConsulta == null ? this.rawConsulta : rawConsulta.value,
      resultadoConsulta: resultadoConsulta == null ? this.resultadoConsulta : resultadoConsulta.value,
      proyecto: proyecto == null ? this.proyecto : proyecto.value
    );
  }
  
  ConsultaWeb.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _imgAnteriorNombreImg = json['imgAnteriorNombreImg'],
      _imgAnteriorSatellite = json['imgAnteriorSatellite'],
      _imgAnteriorYear = (json['imgAnteriorYear'] as num?)?.toInt(),
      _imgAnteriorMesInicial = (json['imgAnteriorMesInicial'] as num?)?.toInt(),
      _imgAnteriorMesFinal = (json['imgAnteriorMesFinal'] as num?)?.toInt(),
      _imgAnteriorNubosidadMaxima = (json['imgAnteriorNubosidadMaxima'] as num?)?.toInt(),
      _imgAnteriorBandas = json['imgAnteriorBandas'],
      _imgPosteriorNombreImg = json['imgPosteriorNombreImg'],
      _imgPosteriorSatellite = json['imgPosteriorSatellite'],
      _imgPosteriorYear = (json['imgPosteriorYear'] as num?)?.toInt(),
      _imgPosteriorMesInicial = (json['imgPosteriorMesInicial'] as num?)?.toInt(),
      _imgPosteriorMesFinal = (json['imgPosteriorMesFinal'] as num?)?.toInt(),
      _imgPosteriorNubosidadMaxima = (json['imgPosteriorNubosidadMaxima'] as num?)?.toInt(),
      _imgPosteriorBandas = json['imgPosteriorBandas'],
      _fechaHoraConsulta = json['fechaHoraConsulta'] != null ? amplify_core.TemporalDateTime.fromString(json['fechaHoraConsulta']) : null,
      _usuarioEmailUpdate = json['usuarioEmailUpdate'],
      _rawConsulta = json['rawConsulta'],
      _resultadoConsulta = json['resultadoConsulta'],
      _proyecto = json['proyecto'] != null
        ? json['proyecto']['serializedData'] != null
          ? ProyectoLegacy.fromJson(new Map<String, dynamic>.from(json['proyecto']['serializedData']))
          : ProyectoLegacy.fromJson(new Map<String, dynamic>.from(json['proyecto']))
        : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'imgAnteriorNombreImg': _imgAnteriorNombreImg, 'imgAnteriorSatellite': _imgAnteriorSatellite, 'imgAnteriorYear': _imgAnteriorYear, 'imgAnteriorMesInicial': _imgAnteriorMesInicial, 'imgAnteriorMesFinal': _imgAnteriorMesFinal, 'imgAnteriorNubosidadMaxima': _imgAnteriorNubosidadMaxima, 'imgAnteriorBandas': _imgAnteriorBandas, 'imgPosteriorNombreImg': _imgPosteriorNombreImg, 'imgPosteriorSatellite': _imgPosteriorSatellite, 'imgPosteriorYear': _imgPosteriorYear, 'imgPosteriorMesInicial': _imgPosteriorMesInicial, 'imgPosteriorMesFinal': _imgPosteriorMesFinal, 'imgPosteriorNubosidadMaxima': _imgPosteriorNubosidadMaxima, 'imgPosteriorBandas': _imgPosteriorBandas, 'fechaHoraConsulta': _fechaHoraConsulta?.format(), 'usuarioEmailUpdate': _usuarioEmailUpdate, 'rawConsulta': _rawConsulta, 'resultadoConsulta': _resultadoConsulta, 'proyecto': _proyecto?.toJson(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'imgAnteriorNombreImg': _imgAnteriorNombreImg,
    'imgAnteriorSatellite': _imgAnteriorSatellite,
    'imgAnteriorYear': _imgAnteriorYear,
    'imgAnteriorMesInicial': _imgAnteriorMesInicial,
    'imgAnteriorMesFinal': _imgAnteriorMesFinal,
    'imgAnteriorNubosidadMaxima': _imgAnteriorNubosidadMaxima,
    'imgAnteriorBandas': _imgAnteriorBandas,
    'imgPosteriorNombreImg': _imgPosteriorNombreImg,
    'imgPosteriorSatellite': _imgPosteriorSatellite,
    'imgPosteriorYear': _imgPosteriorYear,
    'imgPosteriorMesInicial': _imgPosteriorMesInicial,
    'imgPosteriorMesFinal': _imgPosteriorMesFinal,
    'imgPosteriorNubosidadMaxima': _imgPosteriorNubosidadMaxima,
    'imgPosteriorBandas': _imgPosteriorBandas,
    'fechaHoraConsulta': _fechaHoraConsulta,
    'usuarioEmailUpdate': _usuarioEmailUpdate,
    'rawConsulta': _rawConsulta,
    'resultadoConsulta': _resultadoConsulta,
    'proyecto': _proyecto,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ConsultaWebModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ConsultaWebModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final IMGANTERIORNOMBREIMG = amplify_core.QueryField(fieldName: "imgAnteriorNombreImg");
  static final IMGANTERIORSATELLITE = amplify_core.QueryField(fieldName: "imgAnteriorSatellite");
  static final IMGANTERIORYEAR = amplify_core.QueryField(fieldName: "imgAnteriorYear");
  static final IMGANTERIORMESINICIAL = amplify_core.QueryField(fieldName: "imgAnteriorMesInicial");
  static final IMGANTERIORMESFINAL = amplify_core.QueryField(fieldName: "imgAnteriorMesFinal");
  static final IMGANTERIORNUBOSIDADMAXIMA = amplify_core.QueryField(fieldName: "imgAnteriorNubosidadMaxima");
  static final IMGANTERIORBANDAS = amplify_core.QueryField(fieldName: "imgAnteriorBandas");
  static final IMGPOSTERIORNOMBREIMG = amplify_core.QueryField(fieldName: "imgPosteriorNombreImg");
  static final IMGPOSTERIORSATELLITE = amplify_core.QueryField(fieldName: "imgPosteriorSatellite");
  static final IMGPOSTERIORYEAR = amplify_core.QueryField(fieldName: "imgPosteriorYear");
  static final IMGPOSTERIORMESINICIAL = amplify_core.QueryField(fieldName: "imgPosteriorMesInicial");
  static final IMGPOSTERIORMESFINAL = amplify_core.QueryField(fieldName: "imgPosteriorMesFinal");
  static final IMGPOSTERIORNUBOSIDADMAXIMA = amplify_core.QueryField(fieldName: "imgPosteriorNubosidadMaxima");
  static final IMGPOSTERIORBANDAS = amplify_core.QueryField(fieldName: "imgPosteriorBandas");
  static final FECHAHORACONSULTA = amplify_core.QueryField(fieldName: "fechaHoraConsulta");
  static final USUARIOEMAILUPDATE = amplify_core.QueryField(fieldName: "usuarioEmailUpdate");
  static final RAWCONSULTA = amplify_core.QueryField(fieldName: "rawConsulta");
  static final RESULTADOCONSULTA = amplify_core.QueryField(fieldName: "resultadoConsulta");
  static final PROYECTO = amplify_core.QueryField(
    fieldName: "proyecto",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ProyectoLegacy'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ConsultaWeb";
    modelSchemaDefinition.pluralName = "ConsultaWebs";
    
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
      amplify_core.ModelIndex(fields: const ["projectID"], name: "byProyecto"),
      amplify_core.ModelIndex(fields: const ["fechaHoraConsulta"], name: "byFechaConsulta")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGANTERIORNOMBREIMG,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGANTERIORSATELLITE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGANTERIORYEAR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGANTERIORMESINICIAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGANTERIORMESFINAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGANTERIORNUBOSIDADMAXIMA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGANTERIORBANDAS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGPOSTERIORNOMBREIMG,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGPOSTERIORSATELLITE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGPOSTERIORYEAR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGPOSTERIORMESINICIAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGPOSTERIORMESFINAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGPOSTERIORNUBOSIDADMAXIMA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.IMGPOSTERIORBANDAS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.FECHAHORACONSULTA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.USUARIOEMAILUPDATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.RAWCONSULTA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaWeb.RESULTADOCONSULTA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ConsultaWeb.PROYECTO,
      isRequired: false,
      targetNames: ['projectID'],
      ofModelName: 'ProyectoLegacy'
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

class _ConsultaWebModelType extends amplify_core.ModelType<ConsultaWeb> {
  const _ConsultaWebModelType();
  
  @override
  ConsultaWeb fromJson(Map<String, dynamic> jsonData) {
    return ConsultaWeb.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ConsultaWeb';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ConsultaWeb] in your schema.
 */
class ConsultaWebModelIdentifier implements amplify_core.ModelIdentifier<ConsultaWeb> {
  final String id;

  /** Create an instance of ConsultaWebModelIdentifier using [id] the primary key. */
  const ConsultaWebModelIdentifier({
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
  String toString() => 'ConsultaWebModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ConsultaWebModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}