from src.ml.embedding_pipeline_v2 import build_text


def test_build_text_includes_rich_product_context():
    product = {
        "vendor_code": "MG26823",
        "name": "Brake Pad Set",
        "ukrainian_name": "Колодки гальмівні",
        "description": "High quality brake pad set for heavy vehicles.",
        "ukrainian_description": "Комплект для важких вантажівок.",
        "search_name": "Brake pad heavy duty trucks",
        "search_ukrainian_name": "Колодки для вантажних автомобілів",
        "supplier_name": "MG26",
        "weight": 2.5,
        "weight_category": "Medium (1-10kg)",
        "multilingual_status": "Complete",
        "ucgfea": "870830",
        "standard": "ISO9001",
        "is_for_sale": True,
        "is_for_web": True,
        "has_image": True,
    }

    result = build_text(product)

    assert "Name: Brake Pad Set" in result
    assert "Колодки гальмівні" in result
    assert "High quality brake pad set for heavy vehicles." in result
    assert "Supplier: MG26" in result
    assert "Weight category: Medium (1-10kg)" in result
    assert "Category code: 870830" in result
    assert "Weight: 2.5 kg" in result
    assert "For sale" in result
    assert "Available online" in result
    assert "Has image" in result


def test_build_text_ignores_empty_values():
    product = {
        "vendor_code": "   ",
        "name": None,
        "ukrainian_name": "",
        "description": "  ",
        "search_name": None,
        "supplier_name": "",
        "weight": None,
        "is_for_sale": False,
        "is_for_web": False,
        "has_image": False,
    }

    result = build_text(product)

    # Expect no double separators or stray prefixes
    assert result == ""
