class DarwinData {
  String? idTask;
  String? darwinDataId;
  int? ptovta;
  String? cedis;
  int? cuc;
  String? nomcliente;
  String? marca;
  int? codProDarwin;
  String? producto;
  int? codPreventa;
  String? nombrePreventa;
  int? lun;
  int? mar;
  int? mie;
  int? jue;
  int? vie;
  int? sab;
  String? semana;
  int? codemp;
  DateTime? createdOn;

  DarwinData({
    this.idTask,
    this.darwinDataId,
    this.ptovta,
    this.cedis,
    this.cuc,
    this.nomcliente,
    this.marca,
    this.codProDarwin,
    this.producto,
    this.codPreventa,
    this.nombrePreventa,
    this.lun,
    this.mar,
    this.mie,
    this.jue,
    this.vie,
    this.sab,
    this.semana,
    this.codemp,
    this.createdOn,
  });

  DarwinData.fromJson(Map<String, dynamic> json) {
    idTask = json['idTask'] ?? '';
    darwinDataId = json['darwinDataId'] ?? '';
    ptovta = json['ptovta'] ?? 0;
    cedis = json['cedis'] ?? '';
    cuc = json['cuc'] ?? 0;
    nomcliente = json['nomcliente'] ?? '';
    marca = json['marca'] ?? '';
    codProDarwin = json['cod_Pro_Darwin'] ?? 0;
    producto = json['producto'] ?? '';
    codPreventa = json['codPreventa'] ?? 0;
    nombrePreventa = json['nombrePreventa'] ?? '';
    lun = json['lun'] ?? 0;
    mar = json['mar'] ?? 0;
    mie = json['mie'] ?? 0;
    jue = json['jue'] ?? 0;
    vie = json['vie'] ?? 0;
    sab = json['sab'] ?? 0;
    semana = json['semana'] ?? '';
    codemp = json['codemp'] ?? 0;
    createdOn = json['createdOn'] != null ? DateTime.parse(json['createdOn']) : null;
  }

}