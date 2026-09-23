part of 'home_page.dart';

typedef OnLikeCallback = void Function(String title, bool isLiked)?;

class _Card extends StatefulWidget {
  final String text;
  final String descriptionText;
  final String? imageUrl;
  final OnLikeCallback onLike;
  final VoidCallback? onTap;

  const _Card(this.text, this.descriptionText, this.imageUrl, this.onLike, this.onTap);

  factory _Card.fromData(CardEmployeeData data, OnLikeCallback onLike, VoidCallback? onTap) => _Card(data.text, data.descriptionText, data.imageUrl, onLike, onTap);

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        constraints: const BoxConstraints(minHeight: 140),
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
                    topLeft: Radius.circular(15),
                  ),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: (widget.imageUrl == null || widget.imageUrl!.isEmpty)
                        ? const Placeholder()
                        : Image.network(
                      widget.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Placeholder(),
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
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
                              widget.onLike?.call(widget.text, isLiked);
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
      ),
    );
  }
}