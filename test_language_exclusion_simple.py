"""
Test script to verify Polish and other language exclusion

Standalone version - tests language classification logic
"""


def classify_query_language(query: str) -> str:
    """
    Enhanced language classification based on character set and common words

    Detects and excludes Polish and other non-Ukrainian languages

    Args:
        query: Query text

    Returns:
        Language code: 'ukrainian', 'russian', 'polish', 'english', or 'unknown'
    """
    # Polish-specific characters (ą, ć, ę, ł, ń, ó, ś, ź, ż)
    polish_chars = set('ąćęłńóśźżĄĆĘŁŃÓŚŹŻ')

    # Ukrainian-specific characters (і, ї, є, ґ)
    ukrainian_chars = set('іїєґІЇЄҐ')

    # General Cyrillic (shared by Russian, Ukrainian, Belarusian, etc.)
    cyrillic_general = set('абвгдежзийклмнопрстуфхцчшщъыьэюяАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ')

    # Russian-specific character (ы - not used in Ukrainian)
    russian_specific = set('ыъэЫЪЭ')

    # Common Polish words (even without special characters)
    polish_common_words = {
        'klocki', 'hamulcowe', 'filtr', 'oleju', 'amortyzator', 'tarcza',
        'hamulcowa', 'zawieszenie', 'silnik', 'olej', 'części', 'samochodowe',
        'samochód', 'hamulec', 'wałek', 'rozrządu', 'pasek', 'napęd'
    }

    query_lower = query.lower()
    query_chars = set(query_lower)
    query_words = query_lower.split()

    # Check for Polish special characters first (highest priority)
    if any(char in query_chars for char in polish_chars):
        return 'polish'

    # Check for common Polish words (even without special characters)
    if any(word in polish_common_words for word in query_words):
        return 'polish'

    # Check for Ukrainian-specific characters
    if any(char in query_chars for char in ukrainian_chars):
        return 'ukrainian'

    # Check for Russian-specific characters
    if any(char in query_chars for char in russian_specific):
        return 'russian'

    # If contains general Cyrillic but no language-specific markers,
    # default to Ukrainian (our primary language)
    if any(char in query_chars for char in cyrillic_general):
        return 'ukrainian'

    # ASCII-only text
    if query.isascii() and len(query.strip()) > 0:
        return 'english'

    return 'unknown'


def test_language_classification():
    """Test language classification with sample queries"""

    test_cases = [
        # Polish queries (should be detected and excluded)
        ("klocki hamulcowe", "polish", "Polish brake pads"),
        ("filtr oleju", "polish", "Polish oil filter"),
        ("amortyzator", "polish", "Polish shock absorber"),
        ("tarcza hamulcowa", "polish", "Polish brake disc"),
        ("świeca zapłonowa", "polish", "Polish spark plug"),
        ("części samochodowe", "polish", "Polish car parts"),

        # Ukrainian queries (should be accepted)
        ("гвинт кріплення", "ukrainian", "Ukrainian screw"),
        ("фільтр масляний", "ukrainian", "Ukrainian oil filter"),
        ("амортизатор", "ukrainian", "Ukrainian shock absorber"),
        ("тормозні колодки", "ukrainian", "Ukrainian brake pads"),
        ("свічка запалювання", "ukrainian", "Ukrainian spark plug"),
        ("запчастини для авто", "ukrainian", "Ukrainian car parts"),

        # Russian queries (contains ы, ъ, э)
        ("тормозные колодки", "russian", "Russian brake pads (ы)"),
        ("масляный фильтр", "russian", "Russian oil filter (ы)"),
        ("объем двигателя", "russian", "Russian engine volume (ъ)"),

        # English queries (should be accepted)
        ("brake pads", "english", "English brake pads"),
        ("oil filter", "english", "English oil filter"),
        ("shock absorber", "english", "English shock absorber"),

        # Vendor codes (should be English/alphanumeric)
        ("100623SAMKO", "english", "Vendor code"),
        ("SEM1-BP-001", "english", "Vendor code with dashes"),
    ]

    print("\n" + "=" * 100)
    print("LANGUAGE CLASSIFICATION TEST")
    print("=" * 100)

    passed = 0
    failed = 0

    for query, expected_lang, description in test_cases:
        detected_lang = classify_query_language(query)
        status = "✓ PASS" if detected_lang == expected_lang else "✗ FAIL"

        if detected_lang == expected_lang:
            passed += 1
        else:
            failed += 1

        print(f"{status} | Query: '{query:35s}' | Expected: {expected_lang:10s} | Got: {detected_lang:10s} | ({description})")

    print("\n" + "=" * 100)
    print(f"RESULTS: {passed} passed, {failed} failed")
    print("=" * 100)

    # Show which queries would be excluded
    print("\n" + "=" * 100)
    print("EXCLUSION SUMMARY")
    print("=" * 100)

    excluded_langs = {'polish', 'unknown'}

    print("\n⛔ Queries that WILL BE EXCLUDED from cache:")
    for query, expected_lang, description in test_cases:
        detected_lang = classify_query_language(query)
        if detected_lang in excluded_langs:
            print(f"   ✗ {query:35s} | {detected_lang.upper():10s} | {description}")

    print("\n✅ Queries that WILL BE ACCEPTED for caching:")
    for query, expected_lang, description in test_cases:
        detected_lang = classify_query_language(query)
        if detected_lang not in excluded_langs:
            print(f"   ✓ {query:35s} | {detected_lang.upper():10s} | {description}")

    print("\n")

    return failed == 0


if __name__ == "__main__":
    success = test_language_classification()
    exit(0 if success else 1)
