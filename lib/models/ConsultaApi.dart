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


/** This is an auto generated class representing the ConsultaApi type in your schema. */
class ConsultaApi extends amplify_core.Model {
  static const classType = const _ConsultaApiModelType();
  final String id;
  final String? _projectID;
  final String? _cedulaCatastral;
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
  final amplify_core.TemporalDateTime? _fechaHoraActualizacion;
  final String? _usuarioEmailUpdate;
  final bool? _verificado;
  final String? _rawConsulta;
  final String? _resultadoConsulta;
  final String? _hashBlockchain;
  final int? _indexNumberBlockchain;
  final amplify_core.TemporalDateTime? _timestampBlockchain;
  final bool? _onchainBlockchain;
  final String? _txIdBlockchain;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ConsultaApiModelIdentifier get modelIdentifier {
      return ConsultaApiModelIdentifier(
        id: id
      );
  }
  
  String? get projectID {
    return _projectID;
  }
  
  String? get cedulaCatastral {
    return _cedulaCatastral;
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
  
  amplify_core.TemporalDateTime? get fechaHoraActualizacion {
    return _fechaHoraActualizacion;
  }
  
  String? get usuarioEmailUpdate {
    return _usuarioEmailUpdate;
  }
  
  bool get verificado {
    try {
      return _verificado!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get rawConsulta {
    return _rawConsulta;
  }
  
  String? get resultadoConsulta {
    return _resultadoConsulta;
  }
  
  String? get hashBlockchain {
    return _hashBlockchain;
  }
  
  int? get indexNumberBlockchain {
    return _indexNumberBlockchain;
  }
  
  amplify_core.TemporalDateTime? get timestampBlockchain {
    return _timestampBlockchain;
  }
  
  bool get onchainBlockchain {
    try {
      return _onchainBlockchain!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get txIdBlockchain {
    return _txIdBlockchain;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ConsultaApi._internal({required this.id, projectID, cedulaCatastral, imgAnteriorNombreImg, imgAnteriorSatellite, imgAnteriorYear, imgAnteriorMesInicial, imgAnteriorMesFinal, imgAnteriorNubosidadMaxima, imgAnteriorBandas, imgPosteriorNombreImg, imgPosteriorSatellite, imgPosteriorYear, imgPosteriorMesInicial, imgPosteriorMesFinal, imgPosteriorNubosidadMaxima, imgPosteriorBandas, fechaHoraConsulta, fechaHoraActualizacion, usuarioEmailUpdate, required verificado, rawConsulta, resultadoConsulta, hashBlockchain, indexNumberBlockchain, timestampBlockchain, required onchainBlockchain, txIdBlockchain, createdAt, updatedAt}): _projectID = projectID, _cedulaCatastral = cedulaCatastral, _imgAnteriorNombreImg = imgAnteriorNombreImg, _imgAnteriorSatellite = imgAnteriorSatellite, _imgAnteriorYear = imgAnteriorYear, _imgAnteriorMesInicial = imgAnteriorMesInicial, _imgAnteriorMesFinal = imgAnteriorMesFinal, _imgAnteriorNubosidadMaxima = imgAnteriorNubosidadMaxima, _imgAnteriorBandas = imgAnteriorBandas, _imgPosteriorNombreImg = imgPosteriorNombreImg, _imgPosteriorSatellite = imgPosteriorSatellite, _imgPosteriorYear = imgPosteriorYear, _imgPosteriorMesInicial = imgPosteriorMesInicial, _imgPosteriorMesFinal = imgPosteriorMesFinal, _imgPosteriorNubosidadMaxima = imgPosteriorNubosidadMaxima, _imgPosteriorBandas = imgPosteriorBandas, _fechaHoraConsulta = fechaHoraConsulta, _fechaHoraActualizacion = fechaHoraActualizacion, _usuarioEmailUpdate = usuarioEmailUpdate, _verificado = verificado, _rawConsulta = rawConsulta, _resultadoConsulta = resultadoConsulta, _hashBlockchain = hashBlockchain, _indexNumberBlockchain = indexNumberBlockchain, _timestampBlockchain = timestampBlockchain, _onchainBlockchain = onchainBlockchain, _txIdBlockchain = txIdBlockchain, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ConsultaApi({String? id, String? projectID, String? cedulaCatastral, String? imgAnteriorNombreImg, String? imgAnteriorSatellite, int? imgAnteriorYear, int? imgAnteriorMesInicial, int? imgAnteriorMesFinal, int? imgAnteriorNubosidadMaxima, String? imgAnteriorBandas, String? imgPosteriorNombreImg, String? imgPosteriorSatellite, int? imgPosteriorYear, int? imgPosteriorMesInicial, int? imgPosteriorMesFinal, int? imgPosteriorNubosidadMaxima, String? imgPosteriorBandas, amplify_core.TemporalDateTime? fechaHoraConsulta, amplify_core.TemporalDateTime? fechaHoraActualizacion, String? usuarioEmailUpdate, required bool verificado, String? rawConsulta, String? resultadoConsulta, String? hashBlockchain, int? indexNumberBlockchain, amplify_core.TemporalDateTime? timestampBlockchain, required bool onchainBlockchain, String? txIdBlockchain}) {
    return ConsultaApi._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      projectID: projectID,
      cedulaCatastral: cedulaCatastral,
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
      fechaHoraActualizacion: fechaHoraActualizacion,
      usuarioEmailUpdate: usuarioEmailUpdate,
      verificado: verificado,
      rawConsulta: rawConsulta,
      resultadoConsulta: resultadoConsulta,
      hashBlockchain: hashBlockchain,
      indexNumberBlockchain: indexNumberBlockchain,
      timestampBlockchain: timestampBlockchain,
      onchainBlockchain: onchainBlockchain,
      txIdBlockchain: txIdBlockchain);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConsultaApi &&
      id == other.id &&
      _projectID == other._projectID &&
      _cedulaCatastral == other._cedulaCatastral &&
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
      _fechaHoraActualizacion == other._fechaHoraActualizacion &&
      _usuarioEmailUpdate == other._usuarioEmailUpdate &&
      _verificado == other._verificado &&
      _rawConsulta == other._rawConsulta &&
      _resultadoConsulta == other._resultadoConsulta &&
      _hashBlockchain == other._hashBlockchain &&
      _indexNumberBlockchain == other._indexNumberBlockchain &&
      _timestampBlockchain == other._timestampBlockchain &&
      _onchainBlockchain == other._onchainBlockchain &&
      _txIdBlockchain == other._txIdBlockchain;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ConsultaApi {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("projectID=" + "$_projectID" + ", ");
    buffer.write("cedulaCatastral=" + "$_cedulaCatastral" + ", ");
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
    buffer.write("fechaHoraActualizacion=" + (_fechaHoraActualizacion != null ? _fechaHoraActualizacion!.format() : "null") + ", ");
    buffer.write("usuarioEmailUpdate=" + "$_usuarioEmailUpdate" + ", ");
    buffer.write("verificado=" + (_verificado != null ? _verificado!.toString() : "null") + ", ");
    buffer.write("rawConsulta=" + "$_rawConsulta" + ", ");
    buffer.write("resultadoConsulta=" + "$_resultadoConsulta" + ", ");
    buffer.write("hashBlockchain=" + "$_hashBlockchain" + ", ");
    buffer.write("indexNumberBlockchain=" + (_indexNumberBlockchain != null ? _indexNumberBlockchain!.toString() : "null") + ", ");
    buffer.write("timestampBlockchain=" + (_timestampBlockchain != null ? _timestampBlockchain!.format() : "null") + ", ");
    buffer.write("onchainBlockchain=" + (_onchainBlockchain != null ? _onchainBlockchain!.toString() : "null") + ", ");
    buffer.write("txIdBlockchain=" + "$_txIdBlockchain" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ConsultaApi copyWith({String? projectID, String? cedulaCatastral, String? imgAnteriorNombreImg, String? imgAnteriorSatellite, int? imgAnteriorYear, int? imgAnteriorMesInicial, int? imgAnteriorMesFinal, int? imgAnteriorNubosidadMaxima, String? imgAnteriorBandas, String? imgPosteriorNombreImg, String? imgPosteriorSatellite, int? imgPosteriorYear, int? imgPosteriorMesInicial, int? imgPosteriorMesFinal, int? imgPosteriorNubosidadMaxima, String? imgPosteriorBandas, amplify_core.TemporalDateTime? fechaHoraConsulta, amplify_core.TemporalDateTime? fechaHoraActualizacion, String? usuarioEmailUpdate, bool? verificado, String? rawConsulta, String? resultadoConsulta, String? hashBlockchain, int? indexNumberBlockchain, amplify_core.TemporalDateTime? timestampBlockchain, bool? onchainBlockchain, String? txIdBlockchain}) {
    return ConsultaApi._internal(
      id: id,
      projectID: projectID ?? this.projectID,
      cedulaCatastral: cedulaCatastral ?? this.cedulaCatastral,
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
      fechaHoraActualizacion: fechaHoraActualizacion ?? this.fechaHoraActualizacion,
      usuarioEmailUpdate: usuarioEmailUpdate ?? this.usuarioEmailUpdate,
      verificado: verificado ?? this.verificado,
      rawConsulta: rawConsulta ?? this.rawConsulta,
      resultadoConsulta: resultadoConsulta ?? this.resultadoConsulta,
      hashBlockchain: hashBlockchain ?? this.hashBlockchain,
      indexNumberBlockchain: indexNumberBlockchain ?? this.indexNumberBlockchain,
      timestampBlockchain: timestampBlockchain ?? this.timestampBlockchain,
      onchainBlockchain: onchainBlockchain ?? this.onchainBlockchain,
      txIdBlockchain: txIdBlockchain ?? this.txIdBlockchain);
  }
  
  ConsultaApi copyWithModelFieldValues({
    ModelFieldValue<String?>? projectID,
    ModelFieldValue<String?>? cedulaCatastral,
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
    ModelFieldValue<amplify_core.TemporalDateTime?>? fechaHoraActualizacion,
    ModelFieldValue<String?>? usuarioEmailUpdate,
    ModelFieldValue<bool>? verificado,
    ModelFieldValue<String?>? rawConsulta,
    ModelFieldValue<String?>? resultadoConsulta,
    ModelFieldValue<String?>? hashBlockchain,
    ModelFieldValue<int?>? indexNumberBlockchain,
    ModelFieldValue<amplify_core.TemporalDateTime?>? timestampBlockchain,
    ModelFieldValue<bool>? onchainBlockchain,
    ModelFieldValue<String?>? txIdBlockchain
  }) {
    return ConsultaApi._internal(
      id: id,
      projectID: projectID == null ? this.projectID : projectID.value,
      cedulaCatastral: cedulaCatastral == null ? this.cedulaCatastral : cedulaCatastral.value,
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
      fechaHoraActualizacion: fechaHoraActualizacion == null ? this.fechaHoraActualizacion : fechaHoraActualizacion.value,
      usuarioEmailUpdate: usuarioEmailUpdate == null ? this.usuarioEmailUpdate : usuarioEmailUpdate.value,
      verificado: verificado == null ? this.verificado : verificado.value,
      rawConsulta: rawConsulta == null ? this.rawConsulta : rawConsulta.value,
      resultadoConsulta: resultadoConsulta == null ? this.resultadoConsulta : resultadoConsulta.value,
      hashBlockchain: hashBlockchain == null ? this.hashBlockchain : hashBlockchain.value,
      indexNumberBlockchain: indexNumberBlockchain == null ? this.indexNumberBlockchain : indexNumberBlockchain.value,
      timestampBlockchain: timestampBlockchain == null ? this.timestampBlockchain : timestampBlockchain.value,
      onchainBlockchain: onchainBlockchain == null ? this.onchainBlockchain : onchainBlockchain.value,
      txIdBlockchain: txIdBlockchain == null ? this.txIdBlockchain : txIdBlockchain.value
    );
  }
  
  ConsultaApi.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _projectID = json['projectID'],
      _cedulaCatastral = json['cedulaCatastral'],
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
      _fechaHoraActualizacion = json['fechaHoraActualizacion'] != null ? amplify_core.TemporalDateTime.fromString(json['fechaHoraActualizacion']) : null,
      _usuarioEmailUpdate = json['usuarioEmailUpdate'],
      _verificado = json['verificado'],
      _rawConsulta = json['rawConsulta'],
      _resultadoConsulta = json['resultadoConsulta'],
      _hashBlockchain = json['hashBlockchain'],
      _indexNumberBlockchain = (json['indexNumberBlockchain'] as num?)?.toInt(),
      _timestampBlockchain = json['timestampBlockchain'] != null ? amplify_core.TemporalDateTime.fromString(json['timestampBlockchain']) : null,
      _onchainBlockchain = json['onchainBlockchain'],
      _txIdBlockchain = json['txIdBlockchain'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'projectID': _projectID, 'cedulaCatastral': _cedulaCatastral, 'imgAnteriorNombreImg': _imgAnteriorNombreImg, 'imgAnteriorSatellite': _imgAnteriorSatellite, 'imgAnteriorYear': _imgAnteriorYear, 'imgAnteriorMesInicial': _imgAnteriorMesInicial, 'imgAnteriorMesFinal': _imgAnteriorMesFinal, 'imgAnteriorNubosidadMaxima': _imgAnteriorNubosidadMaxima, 'imgAnteriorBandas': _imgAnteriorBandas, 'imgPosteriorNombreImg': _imgPosteriorNombreImg, 'imgPosteriorSatellite': _imgPosteriorSatellite, 'imgPosteriorYear': _imgPosteriorYear, 'imgPosteriorMesInicial': _imgPosteriorMesInicial, 'imgPosteriorMesFinal': _imgPosteriorMesFinal, 'imgPosteriorNubosidadMaxima': _imgPosteriorNubosidadMaxima, 'imgPosteriorBandas': _imgPosteriorBandas, 'fechaHoraConsulta': _fechaHoraConsulta?.format(), 'fechaHoraActualizacion': _fechaHoraActualizacion?.format(), 'usuarioEmailUpdate': _usuarioEmailUpdate, 'verificado': _verificado, 'rawConsulta': _rawConsulta, 'resultadoConsulta': _resultadoConsulta, 'hashBlockchain': _hashBlockchain, 'indexNumberBlockchain': _indexNumberBlockchain, 'timestampBlockchain': _timestampBlockchain?.format(), 'onchainBlockchain': _onchainBlockchain, 'txIdBlockchain': _txIdBlockchain, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'projectID': _projectID,
    'cedulaCatastral': _cedulaCatastral,
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
    'fechaHoraActualizacion': _fechaHoraActualizacion,
    'usuarioEmailUpdate': _usuarioEmailUpdate,
    'verificado': _verificado,
    'rawConsulta': _rawConsulta,
    'resultadoConsulta': _resultadoConsulta,
    'hashBlockchain': _hashBlockchain,
    'indexNumberBlockchain': _indexNumberBlockchain,
    'timestampBlockchain': _timestampBlockchain,
    'onchainBlockchain': _onchainBlockchain,
    'txIdBlockchain': _txIdBlockchain,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ConsultaApiModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ConsultaApiModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final PROJECTID = amplify_core.QueryField(fieldName: "projectID");
  static final CEDULACATASTRAL = amplify_core.QueryField(fieldName: "cedulaCatastral");
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
  static final FECHAHORAACTUALIZACION = amplify_core.QueryField(fieldName: "fechaHoraActualizacion");
  static final USUARIOEMAILUPDATE = amplify_core.QueryField(fieldName: "usuarioEmailUpdate");
  static final VERIFICADO = amplify_core.QueryField(fieldName: "verificado");
  static final RAWCONSULTA = amplify_core.QueryField(fieldName: "rawConsulta");
  static final RESULTADOCONSULTA = amplify_core.QueryField(fieldName: "resultadoConsulta");
  static final HASHBLOCKCHAIN = amplify_core.QueryField(fieldName: "hashBlockchain");
  static final INDEXNUMBERBLOCKCHAIN = amplify_core.QueryField(fieldName: "indexNumberBlockchain");
  static final TIMESTAMPBLOCKCHAIN = amplify_core.QueryField(fieldName: "timestampBlockchain");
  static final ONCHAINBLOCKCHAIN = amplify_core.QueryField(fieldName: "onchainBlockchain");
  static final TXIDBLOCKCHAIN = amplify_core.QueryField(fieldName: "txIdBlockchain");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ConsultaApi";
    modelSchemaDefinition.pluralName = "ConsultaApis";
    
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
      amplify_core.ModelIndex(fields: const ["fechaHoraConsulta"], name: "byFechaConsulta"),
      amplify_core.ModelIndex(fields: const ["hashBlockchain"], name: "byHashBlockchain")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.PROJECTID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.CEDULACATASTRAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGANTERIORNOMBREIMG,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGANTERIORSATELLITE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGANTERIORYEAR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGANTERIORMESINICIAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGANTERIORMESFINAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGANTERIORNUBOSIDADMAXIMA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGANTERIORBANDAS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGPOSTERIORNOMBREIMG,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGPOSTERIORSATELLITE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGPOSTERIORYEAR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGPOSTERIORMESINICIAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGPOSTERIORMESFINAL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGPOSTERIORNUBOSIDADMAXIMA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.IMGPOSTERIORBANDAS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.FECHAHORACONSULTA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.FECHAHORAACTUALIZACION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.USUARIOEMAILUPDATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.VERIFICADO,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.RAWCONSULTA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.RESULTADOCONSULTA,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.HASHBLOCKCHAIN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.INDEXNUMBERBLOCKCHAIN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.TIMESTAMPBLOCKCHAIN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.ONCHAINBLOCKCHAIN,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ConsultaApi.TXIDBLOCKCHAIN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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

class _ConsultaApiModelType extends amplify_core.ModelType<ConsultaApi> {
  const _ConsultaApiModelType();
  
  @override
  ConsultaApi fromJson(Map<String, dynamic> jsonData) {
    return ConsultaApi.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ConsultaApi';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ConsultaApi] in your schema.
 */
class ConsultaApiModelIdentifier implements amplify_core.ModelIdentifier<ConsultaApi> {
  final String id;

  /** Create an instance of ConsultaApiModelIdentifier using [id] the primary key. */
  const ConsultaApiModelIdentifier({
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
  String toString() => 'ConsultaApiModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ConsultaApiModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}