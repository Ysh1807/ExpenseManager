import 'package:expense_manager/widgets/Chart/chart.dart';
import 'package:expense_manager/widgets/expenses_list/expenses_list.dart';
import 'package:expense_manager/models/expense.dart';
import 'package:expense_manager/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 450,
        date: DateTime.now(),
        category: Category.work),
    Expense(
      title: 'Cricket Match',
      amount: 2000,
      date: DateTime.now(),
      category: Category.leisure,
    )
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      //backgroundColor: const Color.fromARGB(255, 232, 211, 236),
      useSafeArea: true, // stay away from device features
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted!'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Manager'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: _registeredExpenses.isEmpty
                      ? const Center(
                          child: Text('No Expenses found. Start adding some!'),
                        )
                      : ExpensesList(
                          onRemoveExpense: _removeExpense,
                          expenses:
                              _registeredExpenses), // expanded because list inside a list
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(
                    child: _registeredExpenses.isEmpty
                        ? const Center(
                            child:
                                Text('No Expenses found. Start adding some!'),
                          )
                        : ExpensesList(
                            onRemoveExpense: _removeExpense,
                            expenses:
                                _registeredExpenses) // expanded because list inside a list
                    )
              ],
            ),
    );
  }
}
