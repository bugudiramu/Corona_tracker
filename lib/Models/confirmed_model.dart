class ConfirmedModel {
  String provinceState;
  String countryRegion;
  Null lastUpdate;
  double lat;
  double long;
  int confirmed;
  int deaths;
  int recovered;
  int active;
  Null fips;
  Null incidentRate;
  Null peopleTested;
  String iso2;
  String iso3;

  ConfirmedModel(
      {this.provinceState,
      this.countryRegion,
      this.lastUpdate,
      this.lat,
      this.long,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.active,
      this.fips,
      this.incidentRate,
      this.peopleTested,
      this.iso2,
      this.iso3});

  ConfirmedModel.fromJson(Map<String, dynamic> json) {
    provinceState = json['provinceState'];
    countryRegion = json['countryRegion'];
    lastUpdate = json['lastUpdate'];
    lat = json['lat'];
    long = json['long'];
    confirmed = json['confirmed'];
    deaths = json['deaths'];
    recovered = json['recovered'];
    active = json['active'];
    fips = json['fips'];
    incidentRate = json['incidentRate'];
    peopleTested = json['peopleTested'];
    iso2 = json['iso2'];
    iso3 = json['iso3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provinceState'] = this.provinceState;
    data['countryRegion'] = this.countryRegion;
    data['lastUpdate'] = this.lastUpdate;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['confirmed'] = this.confirmed;
    data['deaths'] = this.deaths;
    data['recovered'] = this.recovered;
    data['active'] = this.active;
    data['fips'] = this.fips;
    data['incidentRate'] = this.incidentRate;
    data['peopleTested'] = this.peopleTested;
    data['iso2'] = this.iso2;
    data['iso3'] = this.iso3;
    return data;
  }
}
