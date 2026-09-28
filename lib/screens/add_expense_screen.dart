import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  final Map<String, String>? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {

  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedCategory = "Food";

  TextEditingController customCategoryController =
  TextEditingController();


   @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      titleController.text = widget.expense!["title"]!;
      amountController.text = widget.expense!["amount"]!;
      categoryController.text = widget.expense!["category"]!;
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "Add New Expense",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Expense Title",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: [
                  "Food",
                  "Travel",
                  "Shopping",
                  "Bills",
                  "Entertainment",
                  "Other",
                ].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              if (selectedCategory == "Other") ...[
                const SizedBox(height: 15),

                TextField(
                  controller: customCategoryController,
                  decoration: const InputDecoration(
                    labelText: "Enter Custom Category",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 15),

              ElevatedButton.icon(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text("Select Date"),
              ),
              Text(
                "Selected Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      amountController.text.isEmpty ||
                      (selectedCategory == "Other" &&
                          customCategoryController.text.isEmpty)) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all details"),
                      ),
                    );

                    return;
                  }

                  Navigator.pop(
                    context,
                    {
                      "title": titleController.text,
                      "amount": amountController.text,
                      "category": selectedCategory == "Other"
                          ? customCategoryController.text
                          : selectedCategory,
                      "date":
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    },
                  );
                },
                child: Text(
                  widget.expense == null ? "Add Expense" : "Update Expense",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}