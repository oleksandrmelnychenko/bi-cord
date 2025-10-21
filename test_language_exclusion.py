"""
Test script to verify Polish and other language exclusion

Tests the enhanced classify_query_language function
"""

from src.ml.query_cache_loader import classify_query_language


def test_language_classification():
    """Test language classification with sample queries"""

    test_cases = [
        # Polish queries (should be detected and excluded)
        ("klocki hamulcowe", "polish", "Polish brake pads"),
        ("filtr oleju", "polish", "Polish oil filter"),
        ("amortyzator", "polish", "Polish shock absorber"),
        ("tarcza hamulcowa", "polish", "Polish brake disc"),
        ("świeca zapłonowa", "polish", "Polish spark plug"),

        # Ukrainian queries (should be accepted)
        ("гвинт кріплення", "ukrainian", "Ukrainian screw"),
        ("фільтр масляний", "ukrainian", "Ukrainian oil filter"),
        ("амортизатор", "ukrainian", "Ukrainian shock absorber"),
        ("тормозні колодки", "ukrainian", "Ukrainian brake pads"),
        ("свічка запалювання", "ukrainian", "Ukrainian spark plug"),

        # Russian queries (contains ы, ъ, э)
        ("тормозные колодки", "russian", "Russian brake pads"),
        ("масляный фильтр", "russian", "Russian oil filter"),

        # English queries (should be accepted)
        ("brake pads", "english", "English brake pads"),
        ("oil filter", "english", "English oil filter"),
        ("shock absorber", "english", "English shock absorber"),

        # Vendor codes (should be English/alphanumeric)
        ("100623SAMKO", "english", "Vendor code"),
        ("SEM1-BP-001", "english", "Vendor code with dashes"),
    ]

    print("\n" + "=" * 80)
    print("LANGUAGE CLASSIFICATION TEST")
    print("=" * 80)

    passed = 0
    failed = 0

    for query, expected_lang, description in test_cases:
        detected_lang = classify_query_language(query)
        status = "✓ PASS" if detected_lang == expected_lang else "✗ FAIL"

        if detected_lang == expected_lang:
            passed += 1
        else:
            failed += 1

        print(f"{status} | Query: '{query:30s}' | Expected: {expected_lang:10s} | Got: {detected_lang:10s} | ({description})")

    print("\n" + "=" * 80)
    print(f"RESULTS: {passed} passed, {failed} failed")
    print("=" * 80)

    # Show which queries would be excluded
    print("\n" + "=" * 80)
    print("EXCLUSION SUMMARY")
    print("=" * 80)

    excluded_langs = {'polish', 'unknown'}

    print("\nQueries that WILL BE EXCLUDED from cache:")
    for query, expected_lang, description in test_cases:
        detected_lang = classify_query_language(query)
        if detected_lang in excluded_langs:
            print(f"  ✗ {query:30s} | {detected_lang.upper():10s} | {description}")

    print("\nQueries that WILL BE ACCEPTED for caching:")
    for query, expected_lang, description in test_cases:
        detected_lang = classify_query_language(query)
        if detected_lang not in excluded_langs:
            print(f"  ✓ {query:30s} | {detected_lang.upper():10s} | {description}")

    print("\n")

    return failed == 0


if __name__ == "__main__":
    success = test_language_classification()
    exit(0 if success else 1)
