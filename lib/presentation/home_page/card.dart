part of 'home_page.dart';

class _CardEmployeeData {
  final String text;
  final String descriptionText;
  final String? imageUrl;

  new({required this.text, required this.descriptionText, this.imageUrl});
}

class _Card extends StatefulWidget {
  final String text;
  final String descriptionText;
  final String? imageUrl;

  const _Card(this.text, this.descriptionText, this.imageUrl);

  factory _Card.fromData(_CardEmployeeData data) => _Card(data.text, data.descriptionText, data.imageUrl);

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.primaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.5) ,spreadRadius: 4, offset: const Offset(0, 5), blurRadius: 8)]
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15)
                ),
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset(
                    widget.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Placeholder(),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(2, 0),
                            ),
                            Shadow(
                              color: Colors.black,
                              offset: Offset(-2, 0),
                            ),
                            Shadow(
                              color: Colors.black,
                              offset: Offset(0, 2),
                            ),
                            Shadow(
                              color: Colors.black,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.descriptionText,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 16),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                          },
                          child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isLiked
                                  ? const Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                key: ValueKey<int>(0),
                              )
                                  : const Icon(Icons.favorite_border, key: ValueKey<int>(1),)
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}