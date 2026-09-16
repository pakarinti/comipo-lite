import 'package:flutter/material.dart';

void main() {
  runApp(const ComipoLiteApp());
}

class ComipoLiteApp extends StatelessWidget {
  const ComipoLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comipo Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CharacterEditorScreen(),
    );
  }
}

class CharacterEditorScreen extends StatefulWidget {
  const CharacterEditorScreen({super.key});

  @override
  State<CharacterEditorScreen> createState() => _CharacterEditorScreenState();
}

class _CharacterEditorScreenState extends State<CharacterEditorScreen> {
  // State Rotasi Fake 3D (0: Front, 1: 3/4 Right, 2: Side, 3: 3/4 Left)
  int _currentAngleIndex = 0;
  final List<String> _angles = ['Front (0°)', '3/4 Right (45°)', 'Side (90°)', '3/4 Left (315°)'];

  // State Kustomisasi Modular
  int _selectedHair = 1;
  int _selectedExpression = 1;
  int _selectedOutfit = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comipo Lite - 2D Fake 3D Studio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_sharp),
            tooltip: 'Export to Panel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting character to PNG transparent panel...')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. CANVAS VIEWPORT (FAKE 3D RENDER ENGINE)
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyanAccent, width: 1.5),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.accessibility_new, size: 120, color: Colors.cyanAccent),
                    const SizedBox(height: 12),
                    Text(
                      'Angle: ${_angles[_currentAngleIndex]}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Hair #$_selectedHair | Face #$_selectedExpression | Outfit #$_selectedOutfit',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. FAKE 3D ROTATION SLIDER (EASY POSE STYLE)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('360° Angle View Controller:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_angles[_currentAngleIndex], style: const TextStyle(color: Colors.cyanAccent)),
                  ],
                ),
                Slider(
                  value: _currentAngleIndex.toDouble(),
                  min: 0,
                  max: 3,
                  divisions: 3,
                  activeColor: Colors.cyanAccent,
                  onChanged: (val) {
                    setState(() {
                      _currentAngleIndex = val.toInt();
                    });
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // 3. CHARAT STYLE MODULAR SELECTOR
          Expanded(
            flex: 2,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.cyanAccent,
                    tabs: [
                      Tab(icon: Icon(Icons.face), text: 'Hair'),
                      Tab(icon: Icon(Icons.emoji_emotions), text: 'Expression'),
                      Tab(icon: Icon(Icons.checkroom), text: 'Outfit'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab Hair
                        _buildItemGrid(5, _selectedHair, (idx) => setState(() => _selectedHair = idx)),
                        // Tab Expression
                        _buildItemGrid(4, _selectedExpression, (idx) => setState(() => _selectedExpression = idx)),
                        // Tab Outfit
                        _buildItemGrid(6, _selectedOutfit, (idx) => setState(() => _selectedOutfit = idx)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemGrid(int count, int currentSelected, Function(int) onSelect) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        final itemNumber = index + 1;
        final isSelected = itemNumber == currentSelected;
        return InkWell(
          onTap: () => onSelect(itemNumber),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.cyanAccent.withOpacity(0.3) : Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.cyanAccent : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                'Item #$itemNumber',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[400],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
