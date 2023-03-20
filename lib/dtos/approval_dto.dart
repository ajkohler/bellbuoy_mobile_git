class ApprovalDto {
  late final int invoiceId;
  late final String createDate;
  late final String invoiceNumber;
  late final String amount;
  late final String status;
  late final int statusId;
  late final int documentId;
  late bool hasApproved;
  late final int approvers;
  late final int totalApprovers;

  ApprovalDto(
      this.invoiceId,
      this.createDate,
      this.invoiceNumber,
      this.amount,
      this.status,
      this.statusId,
      this.documentId,
      this.hasApproved,
      this.approvers,
      this.totalApprovers);

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'createDate': createDate,
      'amount': amount,
      'invoiceNumber': invoiceNumber,
      'status': status,
      'statusId': statusId,
      'documentId': documentId,
      'hasApproved': hasApproved,
      'approvers': approvers,
      'totalApprovers': totalApprovers
    };
  }

  factory ApprovalDto.fromMap(Map<String, dynamic> json) {
    return ApprovalDto(
        json['invoiceId'],
        json['createDate'],
        json['amount'],
        json['invoiceNumber'],
        json['status'],
        json['statusId'],
        json['documentId'],
        json['hasApproved'],
        json['approvers'],
        json['totalApprovers']);
  }
}
