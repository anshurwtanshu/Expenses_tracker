import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // Store added expenses
  List<Map<String, String>> expenses = [];
  double calculateTotal() {
    double total = 0;

    for (var expense in expenses) {
      total = total + double.parse(expense["amount"]!);
    }

    return total;
  }
  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('IsloggedIn', false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Column(
            children: [

              // Welcome
              const Text(
                "Welcome, Anshul Rawat",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- CARDS ----------------
              Row(
                children: [

                  // Total Expense Card
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            const Icon(
                              Icons.account_balance_wallet,
                              size: 30,
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Total Expense",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "₹${calculateTotal().toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Expenses Card
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),

                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(16),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              const Icon(
                                Icons.receipt_long,
                                size: 32,
                              ),

                              const SizedBox(height: 10),

                              const Text(
                                "Expenses",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 5),

                              // Number of added expenses
                              Text(
                                "${expenses.length}",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------------- ADD EXPENSE BUTTON ----------------
              ElevatedButton(
                onPressed: () async {

                  // Open Add Expense Screen
                  final expense = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const AddExpenseScreen(),
                    ),
                  );

                  // Check if data came back
                  if (expense != null) {

                    setState(() {

                      // Add expense to list
                      expenses.add({
                        "title": expense["title"],
                        "amount": expense["amount"],
                        "category": expense["category"],
                        "date": expense["date"],
                      });

                    });
                  }
                },

                child: const Text("Add Expenses"),
              ),

              const SizedBox(height: 20),

              // ---------------- RECENT EXPENSES ----------------
              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Recent Expenses",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Display expenses
              Expanded(
                child: ListView.builder(

                  itemCount: expenses.length,

                  itemBuilder: (context, index) {

                    final expense = expenses[index];

                    return Card(
                      child: ListTile(

                        leading: const Icon(
                          Icons.receipt_long,
                        ),

                        title: Text(
                          expense["title"]!,
                        ),

                        subtitle: Text(
                          "${expense["category"]!} • ${expense["date"] ?? "No date"}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                            children: [
                            Text(
                              "₹${expense["amount"]!}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),

                            // EDIT BUTTON
                            IconButton(
                              onPressed: () async {
                                final updatedExpense = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddExpenseScreen(
                                      expense: expense,
                                    ),
                                  ),
                                );

                                if (updatedExpense != null) {
                                  setState(() {
                                    expenses[index] = {
                                      "title": updatedExpense["title"],
                                      "amount": updatedExpense["amount"],
                                      "category": updatedExpense["category"],
                                    };
                                  });
                                }
                              },
                              icon: const Icon(Icons.edit),
                            ),

                            // DELETE BUTTON
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  expenses.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}