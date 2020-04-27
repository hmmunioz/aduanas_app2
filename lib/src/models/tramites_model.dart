class TramiteModel {
  String _actividad;
  String _cliente;
  String _responsable;
  int _estado;
  String _id;
  String _numeroTramite;
  String _fechaRegistro;
  String _fechaExpiracion;
  String _tipoTramite;

  TramiteModel(this._actividad, this._cliente, this._responsable, this._estado,
      this._id, this._numeroTramite, this._fechaRegistro, this._fechaExpiracion, this._tipoTramite);

  factory TramiteModel.fromJson(Map<String, dynamic> data) {
    return new TramiteModel(
        data['actividad'],
        data['cliente'],
        data['responsable'],
        data['estado'],
        data['id'],
        data['numeroTramite'],    
        data['fechaRegistro'],
        data['fechaExpiracion'],
        data['tipoTramite'],
        );
  }

  Map<String, dynamic> toJson() => {
        'actividad': getActividad,
        'cliente': getCliente,
        'responsable': getResponsable,
        'estado': getEstado,
        'id': getId,
        'numeroTramite': getNumeroTramite,
        'fechaRegistro': getFechaRegistro,
        'fechaExpiracion': getFechaExpiracion,
        'tipoTramite': getTipoTramite
      };

 TramiteModel.fromDb(Map<String, dynamic> parsedJson):
       _actividad = parsedJson['actividad'],
       _cliente =  parsedJson['cliente'],
       _responsable= parsedJson['responsable'],     
       _estado=  parsedJson['estado'],   
         _id=  parsedJson['id'],
        _numeroTramite = parsedJson['numeroTramite'],
        _fechaRegistro =  parsedJson['fechaRegistro'],
        _fechaExpiracion= parsedJson['fechaExpiracion'],
        _tipoTramite= parsedJson['tipoTramite']
        ;


  String get getActividad => _actividad;
  String get getCliente => _cliente;
  String get getResponsable => _responsable;
  int get getEstado => _estado;
  String get getId => _id;
  String get getNumeroTramite => _numeroTramite;
  String get getFechaRegistro => _fechaRegistro;
  String get getFechaExpiracion => _fechaExpiracion;
  String get getTipoTramite => _tipoTramite;

  void setEstado(int estado){
       _estado= estado;
  }
   

}
