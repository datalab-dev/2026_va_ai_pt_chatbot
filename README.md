# LibBot: UC Davis Library LibGuide Chatbot

> [!IMPORTANT]  
> This project originated as a group collaboration back during 2025 Spring Quarter. The original team prototype was primarily built in R, along with Ollama; team member acknowledgements, resources and data store, and documentation can be found in the [[**v1.0b-STS195**]](https://github.com/datalab-dev/ucd_library_libguide_chatbot/tree/v1.0b-STS195) branch of this repository.

> [!NOTE]
> LibBot's corpus is based on UC Davis LibGuides scraped June 11th, 2026.
> Corpus refreshes are now repeatable through the scraping pipeline — see the [`pipeline/` README](https://github.com/datalab-dev/ucd_library_libguide_chatbot/tree/main/pipeline).

## Current Contributors

-   **Project Lead**: Dr. Carl Stahmer
-   **Lead Developer**: Federico G. Aprile
-   **Maintainer**: Wesley Brooks
-   **UX/UI Designer**: Leon Tanguay

<br>

---

## Project Overview

**LibBot** is a virtual librarian chatbot designed to bring together scattered academic resources into a unified research tool. Developed to support the UC Davis Library, it connects researchers with relevant materials and expertise, maintaining high-quality research support even amidst institutional constraints like reduced librarian availability. _**LibBot is currently deployed on the UC Davis DataLab server and accessible to users on the university VPN.**_

### Technical Implementation

The system transforms the UC Davis library’s corpus of guides and resources into a conversational experience through a structured RAG (Retrieval-Augmented Generation) pipeline:

- **Data Collection & Cleaning**: Systematized scraping and preprocessing of heterogeneous library data to ensure a clean, searchable corpus.
- **Semantic Representation**: Uses Sentence-Transformer models to generate high-quality vector embeddings for documents and queries. These models were benchmarked to balance computational efficiency on CPU-only environments with retrieval accuracy.
- **Retrieval & Context Selection**: A Python/PyTorch-based retrieval engine that uses optimized pooling strategies to identify and rank the most relevant document chunks based on user queries, using cosine similarity.
- **Retrieval-Augmented Generation (RAG)**: A prompt engineering layer that synthesizes the retrieved context and passes it to a Large Language Model (LLM) to generate natural, cited responses and links.

<br>

---

## Getting Started with LibBot

> [!TIP]
> **Accessing and Interacting with LibBot:**
> 1. Connect to the **UC Davis Library VPN**
> 2. Go to http://datasci.library.ucdavis.edu:8075

> [!NOTE]
> If the page doesn't load, verify you are connected to the UC Davis Library VPN.

> [!CAUTION]
> As with all large language model output, use your own critical reading and thinking skills to assess the validity and reliability of this response for your specific query.

<br>

> [!NOTE]
> - For maintainers needing to start or restart the server, see the [`Maintenance Guide`](https://github.com/datalab-dev/2025_startup_libguide_chatbot/blob/libbot/docs/maintenance.md).
> - To verify the package is working independently of the web server, run:
> ``` bash
> pixi run python test_retriever.py "your query here"
> ```

<br>

---
## Project Dependencies
This project uses `Pixi` for environment and dependency management on a Linux x86-64 server running Python 3.10. `Pixi` handles Python versioning, package installation, and task running — no manual pip install or conda environment setup needed. The full dependency list is defined in `pixi.toml`.

| Package | Purpose |
|--------|-------------|
| fastapi / uvicorn | REST API server and ASGI runtime |
| chromadb | Vector database for storing and querying embeddings |
| sentence-transformers / pytorch | Qwen3-Embedding model for query and document encoding |
| pydantic-settings | Request/response validation and .env-based configuration |
| httpx | Async HTTP client for communicating with Ollama |
| ollama | LLM inference (runs as a separate process — see Maintenance Guide) |

> [!NOTE]
> For full environment setup and server operation, see the [Maintenance Guide](https://github.com/datalab-dev/2025_startup_libguide_chatbot/blob/libbot/docs/maintenance.md).

<br>

---

## GitHub File and Directory Structure

``` bash
2025_startup_libguide_chatbot/
  ├── README.md                          # This README
  ├── docs
  │   ├── methodology.md                 # Doc - Methodology and Research Notes
  │   ├── maintenance.md                 # Doc - LibBot server maintenance/configuration
  │   ├── ollama.md                      # Doc - LLM configuration and Modelfiles
  │   └── assets                         # Images
  │       └── ...
  ├── libbot_pkg/                        # Main package - see dedicated README
  │   └── ...
  ├── research/                          # Model benchmarking — see dedicated README
  │   └── ...
  ├── pipeline/                          # Corpus scraping/refresh pipeline — see dedicated README
  │   └── ...
  ├── models/                            # Ollama models — see dedicated README
  │   └── ...
  │
  ├── test_retriever.py                  # Testing whether libbot_pkg module imports work on a simple script
  ├── .gitignore/.gitattributes          # What files Git should not track, and how Git should handle the files it does track
  └── pixi.toml                          # Environment and dependency definitions
```
### [**Dedicated `libbot_pkg/` README**](https://github.com/datalab-dev/2025_startup_libguide_chatbot/tree/libbot/libbot_pkg)

### [**Dedicated `research/` README**](https://github.com/datalab-dev/2025_startup_libguide_chatbot/tree/libbot/research)

### [**Dedicated `pipeline/` README**](https://github.com/datalab-dev/ucd_library_libguide_chatbot/tree/main/pipeline)

### [**Dedicated `models/` README**](https://github.com/datalab-dev/ucd_library_libguide_chatbot/blob/main/docs/ollama.md)

<br>

## Getting Started
On October 22 2026, Wesley Brooks copied the following instructions from Slack, which indicate how to get the LibBot up and running on a local computer (e.g., his MacBook Air, using the GPU [aka MPS] for inference):

> Hi Natalia and Sabrina! I've done some work to make the LibBot more adaptable to running on different hardware. It is now at the point where I can run tests at the command line but I am still working to get the web chat interface running on my computer. The biggest difference is that I have created a single file that controls things like where the files and databases should be found, so we won't have to figure out what should be in the environment file and what should be entered at the command line.
> 
> In any case, I am now going to check in my updates to a branch of the Github repository called wb-parameterize.
> 
> I'll send another update once I have finished checking in that code. Then you should be able to pull it from Github and catch up to the point I'm at. (edited) 
> Sabrina Cheung  [10:48 AM]
> Thank you so much for all your help Wesley!
> Wesley  [11:06 AM]
> OK, I've checked in my code. You can get it by going to the project folder and running these at the command line:
> 
> git fetch
> 
> git switch -c wb-parameterize --track origin/wb-parameterize
> 
> git pull(edited)
> Wesley  [11:12 AM]
> That should cause Git to switch to a new branch on your computer called wb-parameterize that tracks the branch wb-parameterize from the Github repository. Then you are ready to try building the database that the chatbot uses to provide answers (this may take an hour or so, depending on your computer's processing power):
> 
> pixi install
> pixi run python pipeline/build_chromadb.py[11:15 AM]After that you can test the system's basic functionality by making a query to the LLM and seeing whether it gives you responses or error messages:
> 
> pixi run python test_retriever.py "put some question here in quotes"
> [11:18 AM]If you can confirm that is all working, then I think your next step is to look into the file libbot_pkg/api.py and find the function called build_context_prompt(). Read through its code and try to understand how it builds a query by combining the current input with past messages in the same conversation. I think this is where you will be working to give the bot more or better context, which can improve its responses.
> Wesley  [3:40 PM]
> I just realized that these changes weren't on the Github repository yet. I just pushed them. I also figured out how to get the chatbot interface working
> [3:41 PM]once you have checked out the wb-parameterize branch, everything is ready to work but the process of starting the chatbot takes a few steps:
> Wesley  [3:48 PM]
> 
> 1. Start ollama in a terminal window. cd into the project folder and run the command `pixi run ollama-serve`.
> 2. (This only has to be done once.) Install the chat model from the internet. From the a separate terminal window, cd to your project folder and run the command `pixi run ollama-pull gemma3:4b`.
> 3.Start the LibBot. In the same terminal as step 2, run the command `pixi run python -m libbot_pkg`.
> 
> 
> The final step takes a few seconds. You'll know the LibBot is up and ready to test when you see a message in the terminal like
> 
> INFO:     Application startup complete.
> INFO:     Uvicorn running on http://0.0.0.0:8075 (Press CTRL+C to quit)

> Then open a web browser and enter the address localhost:8075. You should see the LibBot chat, which you can try prompting with questions. Let me know how this goes for you! (edited)


---

## Methodology
[**Dedicated `Methodology` Notes**](https://github.com/datalab-dev/ucd_library_libguide_chatbot/blob/main/docs/methodology.md) doc that covers the highlights of the research, considerations, and the decisions made at every step of this project--from working on the corpus, to experimenting with embedding models, facilitating retrieval, and more.

<br>

---

## Example LibBot Interaction:
![LiBot Landing Page](docs/assets/libbot_landing_page.png)
![LiBot Interaction Example 1](docs/assets/libbot_interaction_example_1.png)
![LiBot Interaction Example 2](docs/assets/libbot_interaction_example_2.png)

