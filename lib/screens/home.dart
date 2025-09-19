import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  void _addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  void _deleteTask(int id) {
    setState(() {
      tasks.removeWhere((task) => task.id == id);
    });
  }

  void _toggleTaskStatus(int id) {
    setState(() {
      final taskIndex = tasks.indexWhere((task) => task.id == id);
      if (taskIndex != -1) {
        tasks[taskIndex].isCompleted = !tasks[taskIndex].isCompleted;
      }
    });
  }

  void _editTask(Task updatedTask) {
    setState(() {
      final index = tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        tasks[index] = updatedTask;
      }
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAddTask: _addTask,
        nextId: tasks.isNotEmpty ? tasks.last.id + 1 : 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingTasks = tasks.where((task) => !task.isCompleted).toList();
    final completedTasks = tasks.where((task) => task.isCompleted).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('To-Do App'),
          backgroundColor: Colors.lightBlue,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending Tasks'),
              Tab(text: 'Completed Tasks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pending Tasks Tab
            TaskList(
              tasks: pendingTasks,
              onDeleteTask: _deleteTask,
              onToggleTaskStatus: _toggleTaskStatus,
              onEditTask: _editTask,
              emptyMessage: 'No pending tasks. Add a new task!',
            ),
            // Completed Tasks Tab
            TaskList(
              tasks: completedTasks,
              onDeleteTask: _deleteTask,
              onToggleTaskStatus: _toggleTaskStatus,
              onEditTask: _editTask,
              emptyMessage: 'No completed tasks yet.',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTaskDialog,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class Task {
  int id;
  String title;
  String description;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(int) onDeleteTask;
  final Function(int) onToggleTaskStatus;
  final Function(Task) onEditTask;
  final String emptyMessage;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onDeleteTask,
    required this.onToggleTaskStatus,
    required this.onEditTask,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${tasks.length} ${tasks.length == 1 ? 'task' : 'tasks'}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      emptyMessage,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskItem(
                        task: task,
                        onDelete: () => onDeleteTask(task.id),
                        onToggleStatus: () => onToggleTaskStatus(task.id),
                        onEdit: () {
                          showDialog(
                            context: context,
                            builder: (context) => AddTaskDialog(
                              onAddTask: onEditTask,
                              task: task,
                              isEditing: true,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleStatus,
    required this.onEdit,
  });

  String _formatDate(DateTime date) {
    // Simple date formatting without intl package
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: task.isCompleted ? Colors.green : Colors.grey,
          ),
          onPressed: onToggleStatus,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 4),
            Text(
              'Due: ${_formatDate(task.dueDate)}',
              style: TextStyle(
                color: task.dueDate.isBefore(DateTime.now()) && !task.isCompleted
                    ? Colors.red
                    : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onAddTask;
  final Task? task;
  final bool isEditing;
  final int? nextId;

  const AddTaskDialog({
    super.key,
    required this.onAddTask,
    this.task,
    this.isEditing = false,
    this.nextId,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _dueDate = widget.task!.dueDate;
    } else {
      _dueDate = DateTime.now().add(const Duration(days: 1));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Task' : 'Add New Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Due Date: '),
                  TextButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _dueDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _dueDate = selectedDate;
                        });
                      }
                    },
                    child: Text(_formatDate(_dueDate)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final task = Task(
                id: widget.isEditing ? widget.task!.id : widget.nextId!,
                title: _titleController.text,
                description: _descriptionController.text,
                dueDate: _dueDate,
                isCompleted: widget.isEditing ? widget.task!.isCompleted : false,
              );
              widget.onAddTask(task);
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}