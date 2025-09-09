from fastapi import APIRouter

router = APIRouter()

@router.get("/learn")
def index():
    # Simulate featured tutorials and learning paths
    return {
        "featured_tutorials": [],
        "learning_paths": [],
        "popular_tutorials": [],
        "skill_categories": [],
        "recent_additions": []
    }

@router.get("/learn/tutorials")
def tutorials():
    return {
        "all_tutorials": [],
        "categories": [],
        "difficulty_levels": [],
        "filters": {}
    }
