extension DateTimeTimestamp on DateTime {
  String toTimeStamp() {
    String year = this.year.toString();
    String month = this.month.toString().padLeft(2,"0");
    String day = this.day.toString().padLeft(2,"0");
    String hour = this.hour.toString().padLeft(2,"0");
    String minute = this.minute.toString().padLeft(2,"0");
    String second = this.second.toString().padLeft(2,"0");
    return "$year-$month-$day @ $hour:$minute:$second";
  }
}