
String fileNameFromPath(String path) {
    String out = path.replaceAll("\\", "/");
    RegExp reg = RegExp(r"[/](.*)\.");
    out = reg.firstMatch(out)?.group(1) ?? "";
    out = out.split("/").last;
    return out;
}