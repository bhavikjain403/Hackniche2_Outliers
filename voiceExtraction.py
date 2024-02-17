import spacy
from spacy.matcher import Matcher
import db
import menu

def extract_order_spacy_ner(text):
    # Load language model (replace with your language)
    nlp = spacy.load("en_core_web_sm")

    # Create a matcher to identify specific patterns
    matcher = Matcher(nlp.vocab)

    # Define patterns for quantities and dish names
    patterns = [
        # Quantity + dish name (e.g., "2 pizzas")
        [{"POS": "NUM"}, {"POS": "NOUN"}],
        # Quantity + optional modifier + dish name (e.g., "1 large pizza")
        [{"POS": "NUM"}, {"POS": "ADJ", "OP": "?"}, {"POS": "NOUN"}],
        # Dish name without explicit quantity (e.g., "chicken tikka masala")
        [{"POS": "NOUN"}],  # Refine with more specific tags if possible
    ]

    # Add patterns to the matcher
    for pattern in patterns:
        matcher.add("dish_quantity", [pattern], on_match=None)
    # Process text
    lower = [i.lower() for i in text.split(" ")]
    val = ' '.join(lower)

    doc = nlp(val)
    matches = matcher(doc)

    # Extract information from matches
    order_items = []

    for match in matches:
        id, start, end = match[0], match[1], match[2]
        extracted = doc[start:end].text

        items = extracted.split(" ")
        # print(items)

        nums = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]

        dish_order = {}
        if(items[0].isnumeric() or items[0] in nums):
            dish_order["dish"] = ' '.join(items[1:])
            
            if(items[0].isnumeric()):
                dish_order["quantity"] = int(items[0])
            else:
                dish_order["quantity"] = nums.index(items[0])+1

            order_items.append(dish_order)

    return order_items

# Example usage
# text = "i want to eat 5 pizzas and 4 pepsis"
# extracted_order = extract_order_spacy_ner(text)
# print(extracted_order)
