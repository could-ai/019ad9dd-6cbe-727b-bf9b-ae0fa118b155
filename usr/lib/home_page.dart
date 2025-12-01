import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sql_generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbTemplateType _selectedTemplate = DbTemplateType.singleTenant;
  final TextEditingController _tableNameController = TextEditingController();
  final TextEditingController _schemaNameController = TextEditingController(text: 'public');
  final TextEditingController _columnsController = TextEditingController(text: "name VARCHAR(255) NOT NULL\ndescription TEXT\nstatus VARCHAR(50) DEFAULT 'active'");
  
  String _generatedSql = '';

  @override
  void initState() {
    super.initState();
    _generateSql(); // Generate initial preview
  }

  void _generateSql() {
    setState(() {
      _generatedSql = SqlGenerator.generate(
        type: _selectedTemplate,
        tableName: _tableNameController.text,
        schemaName: _schemaNameController.text,
        columnsInput: _columnsController.text,
      );
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedSql));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SQL copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive layout: Split screen on wide screens, column on narrow
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SQL Script Generator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateSql,
            tooltip: 'Regenerate',
          ),
        ],
      ),
      body: isWide ? _buildWideLayout() : _buildNarrowLayout(),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: _buildForm(),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 3,
          child: _buildPreview(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildForm(),
          const Divider(height: 32),
          SizedBox(
            height: 500, // Fixed height for preview in mobile view
            child: _buildPreview(),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuration',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 24),
        
        Text('Template Type', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<DbTemplateType>(
          segments: const [
            ButtonSegment(
              value: DbTemplateType.singleTenant,
              label: Text('Single Tenant'),
              icon: Icon(Icons.person),
            ),
            ButtonSegment(
              value: DbTemplateType.multiTenant,
              label: Text('Multi-Tenant'),
              icon: Icon(Icons.people),
            ),
          ],
          selected: {_selectedTemplate},
          onSelectionChanged: (Set<DbTemplateType> newSelection) {
            setState(() {
              _selectedTemplate = newSelection.first;
              _generateSql();
            });
          },
        ),
        
        const SizedBox(height: 24),
        TextField(
          controller: _schemaNameController,
          decoration: const InputDecoration(
            labelText: 'Schema Name',
            hintText: 'e.g., public, app',
          ),
          onChanged: (_) => _generateSql(),
        ),
        
        const SizedBox(height: 16),
        TextField(
          controller: _tableNameController,
          decoration: const InputDecoration(
            labelText: 'Table Name',
            hintText: 'e.g., users, orders',
          ),
          onChanged: (_) => _generateSql(),
        ),
        
        const SizedBox(height: 16),
        TextField(
          controller: _columnsController,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: 'Columns (One per line)',
            hintText: 'column_name TYPE constraints...',
            alignLabelWithHint: true,
          ),
          style: const TextStyle(fontFamily: 'monospace'),
          onChanged: (_) => _generateSql(),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter column definitions exactly as they should appear in SQL.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
        
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _generateSql,
            icon: const Icon(Icons.code),
            label: const Text('Generate SQL'),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Container(
      color: const Color(0xFF1E1E1E), // Dark background for code
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF2D2D2D),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Generated Script',
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
                  label: const Text('Copy', style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                _generatedSql,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: Color(0xFFD4D4D4), // VS Code default text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
