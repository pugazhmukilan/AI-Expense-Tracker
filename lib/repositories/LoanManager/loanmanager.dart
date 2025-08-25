import 'package:ai_expense/repositories/LoanManager/loan.dart';
import 'package:uuid/uuid.dart';

class LoanManager {
  static final List<Loan> _loans = [
    Loan(
      id: const Uuid().v4(),
      name: "Personal Loan",
      amount: 5000.0,
      endDate: DateTime(2025, 12, 31),
    ),
    Loan(
      id: const Uuid().v4(),
      name: "Car Loan",
      amount: 12000.0,
      endDate: DateTime(2026, 6, 15),
    ),
    Loan(
      id: const Uuid().v4(),
      name: "Education Loan",
      amount: 20000.0,
      endDate: DateTime(2027, 3, 10),
    ),
    Loan(
      id: const Uuid().v4(),
      name: "Home Loan",
      amount: 75000.0,
      endDate: DateTime(2030, 1, 1),
    ),
    Loan(
      id: const Uuid().v4(),
      name: "Home Loan",
      amount: 75000.0,
      endDate: DateTime(2030, 1, 1),
    ),
    Loan(
      id: const Uuid().v4(),
      name: "Home ",
      amount: 75000.0,
      endDate: DateTime(2030, 1, 1),
    ),
  ];


  // Getter for loans
   static List<Loan> get loans => _loans;

  
  static void loadFromJson(List<dynamic> jsonData) {
    _loans.clear();
    _loans.addAll(jsonData.map((e) => Loan.fromJson(e)).toList());
  }

  static void addLoan(Loan loan) {
    _loans.add(loan);
  }

  static void deleteLoan(String id) {
    _loans.removeWhere((loan) => loan.id == id);
  }

  
  static void updateLoan(Loan updatedLoan) {
    int index = _loans.indexWhere((loan) => loan.id == updatedLoan.id);
    if (index != -1) {
      _loans[index] = updatedLoan;
    }
  }

  static Future<void> pushToDatabase() async {
    // TODO: Replace this with your actual MongoDB API call
    print("Pushing data to DB...");
    for (var loan in _loans) {
      print(loan.toJson());
    }
  }
}
