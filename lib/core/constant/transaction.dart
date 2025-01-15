enum TransactionStatusCategory {progress, done, late, cancel, all, reschedule}

String getTransactionStatusCategoryStr(TransactionStatusCategory trxStatusCategory){
  switch (trxStatusCategory){
    case TransactionStatusCategory.progress:
      return "PROGRESS";
    case TransactionStatusCategory.done:
      return "FINISH";
    case TransactionStatusCategory.late:
      return "PROGRESS";
    case TransactionStatusCategory.cancel:
      return "CANCEL";
    case TransactionStatusCategory.all:
      return "";
    case TransactionStatusCategory.reschedule:
      return "RESCHEDULE";
  } 
}