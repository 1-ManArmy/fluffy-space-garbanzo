from fastapi import APIRouter

router = APIRouter()

@router.get("/press")
def index():
    # Simulate press articles
    press_articles = [
        {
            "id": "techcrunch",
            "publication": "TechCrunch",
            "title": "Revolutionary AI Platform Changing How People Learn to Code",
            "date": "December 15, 2025",
            "excerpt": "OneLastAI's phantom-powered learning platform represents a quantum leap in educational technology, offering personalized AI mentorship that adapts to each learner's unique style and pace.",
            "logo": "TC",
            "color_start": "#16a085",
            "color_end": "#27ae60",
            "rating": 5,
            "tags": ["AI Innovation", "EdTech", "Breakthrough"],
            "author": "Sarah Chen",
            "read_time": 8,
            "full_content": "In the rapidly evolving landscape of artificial intelligence and education technology, OneLastAI has emerged as a revolutionary force that's fundamentally changing how people approach learning to code.<br><br>The platform's phantom AI technology represents a breakthrough in personalized learning, offering an experience that feels almost magical in its ability to anticipate and respond to learner needs.<br><br>We're not just teaching code; we're creating a new paradigm where AI becomes your personal coding mentor, understanding your learning style and adapting in real-time, explains the OneLastAI development team.<br><br>What sets OneLastAI apart is its ability to create truly personalized learning experiences that evolve with each interaction, making coding education more accessible and effective than ever before."
        },
        {
            "id": "forbes",
            "publication": "Forbes",
            "title": "Best AI Learning Platform of 2025: OneLastAI Dominates the Market",
            "date": "October 10, 2025",
            "excerpt": "Forbes recognizes OneLastAI as the premier AI-powered learning platform transforming education and professional development, setting new industry standards.",
            "logo": "FB",
            "color_start": "#3498db",
            "color_end": "#2980b9",
            "rating": 5,
            "tags": ["Business Innovation", "Market Leader", "Awards"],
            "author": "Jennifer Walsh",
            "read_time": 10,
            "full_content": "Forbes recognizes OneLastAI as the premier AI-powered learning platform transforming education and professional development in 2025.<br><br>With its innovative phantom AI technology and comprehensive suite of learning tools, OneLastAI has established itself as the gold standard for AI-assisted education.<br><br>OneLastAI represents the future of learning - where artificial intelligence doesn't replace human creativity but amplifies it exponentially, states the Forbes Editorial Board.<br><br>The platform's market dominance stems from its unique ability to combine cutting-edge AI technology with deeply human-centered learning experiences, creating an educational environment that's both technologically advanced and emotionally engaging."
        }
    ]
    return {"press_articles": press_articles}
