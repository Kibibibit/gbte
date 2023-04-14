
T reduce<T,U>(T Function(T acc,U elem) function, T acc, List<U> list) {

  if (list.isNotEmpty) {
    List<U> newList = list.sublist(1);
    U elem = list.first;
    T newAcc = function(acc, elem);
    return reduce(function,newAcc,newList);
  } else {
    return acc;
  }

}


