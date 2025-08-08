from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr
from typing import List, Optional
import time
import uvicorn

app = FastAPI(title="Python API Server", version="1.0.0")

class User(BaseModel):
    id: int
    name: str
    email: str

class CreateUserRequest(BaseModel):
    name: str
    email: EmailStr

class UpdateUserRequest(BaseModel):
    name: Optional[str] = None
    email: Optional[EmailStr] = None

users_db = [
    User(id=1, name="John Doe", email="john@example.com"),
    User(id=2, name="Jane Smith", email="jane@example.com"),
]

next_id = 3

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "timestamp": int(time.time()),
        "service": "python-api-server"
    }

@app.get("/users")
async def get_users():
    return {
        "users": users_db,
        "total": len(users_db)
    }

@app.get("/users/{user_id}")
async def get_user_by_id(user_id: int):
    for user in users_db:
        if user.id == user_id:
            return user
    raise HTTPException(status_code=404, detail="User not found")

@app.post("/users", status_code=201)
async def create_user(user_request: CreateUserRequest):
    global next_id
    new_user = User(
        id=next_id,
        name=user_request.name,
        email=user_request.email
    )
    users_db.append(new_user)
    next_id += 1
    return new_user

@app.put("/users/{user_id}")
async def update_user(user_id: int, user_request: UpdateUserRequest):
    for i, user in enumerate(users_db):
        if user.id == user_id:
            if user_request.name is not None:
                users_db[i].name = user_request.name
            if user_request.email is not None:
                users_db[i].email = user_request.email
            return users_db[i]
    raise HTTPException(status_code=404, detail="User not found")

@app.delete("/users/{user_id}")
async def delete_user(user_id: int):
    for i, user in enumerate(users_db):
        if user.id == user_id:
            users_db.pop(i)
            return {"message": "User deleted successfully"}
    raise HTTPException(status_code=404, detail="User not found")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8080)