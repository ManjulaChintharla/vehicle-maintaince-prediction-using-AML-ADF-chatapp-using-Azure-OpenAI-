from flask import Flask, render_template, request, jsonify
from your_notebook_module import search_index  # Import your existing function

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/ask", methods=["POST"])
def ask():
    data = request.json
    query = data.get("message", "")
    
    if not query:
        return jsonify({"response": "No question received."})
    
    try:
        response_text = search_index(query)
        return jsonify({"response": response_text})
    except Exception as e:
        return jsonify({"response": f"Error: {str(e)}"})

if __name__ == "__main__":
    app.run(debug=True)

