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
  // Angle Rotasi (0: Front, 1: 3/4 Right, 2: Side, 3: 3/4 Left)
  int _currentAngleIndex = 0;
  final List<String> _angles = ['Front (0°)', '3/4 Right (45°)', 'Side (90°)', '3/4 Left (315°)'];

  // State Aset Modular (Z-Index Layering)
  int _selectedHair = 1;
  int _selectedExpression = 1;
  int _selectedOutfit = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comipo Lite Studio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export to Panel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Karakter siap di-export ke Canvas Manga!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. STACK RENDERING ENGINE (LAYER Z-INDEX)
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent, width: 1.5),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Layer 0: Background Grid Canvas Manga
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GridPainter(),
                    ),
                  ),
                  
                  // Layer 1: Avatar Render Node
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tampilan Visual Karakter Dummy
                        Container(
                          width: 180,
                          height: 240,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Layer A: Base Body / Pose Frame
                              Icon(
                                _currentAngleIndex == 2 ? Icons.accessibility : Icons.accessibility_new,
                                size: 140,
                                color: Colors.grey[300],
                              ),
                              // Layer B: Outfit Overlay
                              Positioned(
                                bottom: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  color: Colors.cyanAccent.withOpacity(0.2),
                                  child: Text('Outfit #$_selectedOutfit', style: const TextStyle(fontSize: 10)),
                                ),
                              ),
                              // Layer C: Expression Overlay
                              Positioned(
                                top: 40,
                                child: Text('Exp #$_selectedExpression', style: const TextStyle(fontSize: 10, color: Colors.yellowAccent)),
                              ),
                              // Layer D: Hair Overlay
                              Positioned(
                                top: 15,
                                child: Text('Hair #$_selectedHair', style: const TextStyle(fontSize: 10, color: Colors.cyanAccent)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Angle View: ${_angles[_currentAngleIndex]}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.cyanAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. FAKE 3D ROTATION SLIDER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rotasi Angle 360°:', style: TextStyle(fontWeight: FontWeight.bold)),
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

          // 3. CHARAT ITEM SELECTOR
          Expanded(
            flex: 2,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: Colors.cyanAccent,
                    tabs: [
                      Tab(icon: Icon(Icons.face), text: 'Rambut'),
                      Tab(icon: Icon(Icons.emoji_emotions), text: 'Ekspresi'),
                      Tab(icon: Icon(Icons.checkroom), text: 'Pakaian'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildItemGrid(6, _selectedHair, (idx) => setState(() => _selectedHair = idx)),
                        _buildItemGrid(5, _selectedExpression, (idx) => setState(() => _selectedExpression = idx)),
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
                '#$itemNumber',
                style: TextStyle(
                  color: isSelected ? Colors.cyanAccent : Colors.grey[400],
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

// Background Grid Canvas Painter
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    const double step = 20;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
