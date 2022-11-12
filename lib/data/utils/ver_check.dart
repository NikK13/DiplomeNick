class AppVC{
  int? version;
  int? subVersion;
  int? subBuild;

  AppVC({
    this.version,
    this.subVersion,
    this.subBuild
  });

  factory AppVC.parse(String version){
    final posLast = version.lastIndexOf('.');
    final posFirst = version.indexOf('.');
    final lastBuild = (posLast != -1)? version.substring(posLast + 1, version.length): version;
    final ver = (posFirst != -1)? version.substring(0, posFirst): version;
    final subVer = (posFirst != -1)? version.substring(posFirst + 1, posLast): version;

    return AppVC(
      version: int.parse(ver),
      subVersion: int.parse(subVer),
      subBuild: int.parse(lastBuild)
    );
  }

  bool isHigherThanNow(AppVC versionTwo){
    if(version! > versionTwo.version! || subVersion! > versionTwo.subVersion! || subBuild! > versionTwo.subBuild!){
      return true;
    }
    else{
      return false;
    }
  }
}