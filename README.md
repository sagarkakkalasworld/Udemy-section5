# 🚀 GitHub Actions CI/CD with Self-Hosted Runner on AWS

This project demonstrates how to set up a **GitHub Actions CI/CD pipeline** using a **self-hosted runner** on an **AWS EC2 instance**. The self-hosted runner connects to a **Demo Server via SSH** to build and deploy a React app using shell scripts.

---

## 🔍 Explore GitHub Actions Marketplace

You can discover useful actions to enhance your workflows here:  
🔗 [GitHub Actions Marketplace](https://github.com/marketplace?type=actions)

---

## 🛠️ Step-by-Step Setup

### 🖥️ Step 1: Create AWS EC2 Instance & Setup SSH

1. Launch an EC2 instance for the **self-hosted runner**.
2. Ensure SSH access is set up between the **runner** and the **demo server**.

---

### 🔑 Step 2: Generate SSH Key Pair

```bash
ssh-keygen
````

> This creates a key pair at:
>
> * `/home/ubuntu/.ssh/id_rsa` (private key)
> * `/home/ubuntu/.ssh/id_rsa.pub` (public key)

**Next:**
Copy the contents of `id_rsa.pub` into the `~/.ssh/authorized_keys` file on the **Demo Server**.

---

### 🔁 Step 3: Test SSH Connection

```bash
ssh ubuntu@<DEMO_SERVER_PRIVATE_IP>
exit
```

---

### 🔐 Step 4: Store Private Key in GitHub Secrets

1. Go to your GitHub Repository
2. Navigate to: `Settings > Secrets and Variables > Actions > New Repository Secret`
3. Name it: `REACT_DEMO`
   Paste your **private key** content.

---

### 🏃 Step 5: Configure GitHub Self-Hosted Runner

```bash
mkdir actions-runner && cd actions-runner

curl -o actions-runner-linux-x64-2.323.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-x64-2.323.0.tar.gz

echo "0dbc9bf5a58620fc52cb6cc0448abcca964a8d74b5f39773b7afcad9ab691e19  actions-runner-linux-x64-2.323.0.tar.gz" | shasum -a 256 -c

tar xzf ./actions-runner-linux-x64-2.323.0.tar.gz

./config.sh --url https://github.com/sagarkakkalasworld/Udemy-section5 --token <YOUR_RUNNER_TOKEN>

./run.sh
```

---

### 🏷️ Step 6: Use Labels for Targeting

Use labels like `cicd` in addition to `self-hosted` in your workflow for better targeting.

---

### 🧩 Step 7: Use SSH Action from Marketplace

We use `webfactory/ssh-agent` to handle SSH keys securely in the GitHub workflow.
🔗 [webfactory/ssh-agent](https://github.com/webfactory/ssh-agent)

---

## 🛠️ Step 8: GitHub Actions Workflow

Create `.github/workflows/React-CI-CD.yaml` in your repository:

```yaml
name: React-CI-CD

on:
  push:
    # branches: [ "main" ]
    tags:
      - "v1*"
  workflow_dispatch:

env:
  DEMO_SERVER: 172.31.30.63  # Replace with your Demo Server private IP

jobs:
  pre-requisites:
    name: Pre-requisites Stage
    runs-on: [self-hosted]
    steps:
      - name: Setup SSH Agent
        uses: webfactory/ssh-agent@v0.9.0
        with:
          ssh-private-key: ${{ secrets.REACT_DEMO }}

      - name: Pull latest code and set script permissions
        run: |
          ssh -o StrictHostKeyChecking=no ubuntu@${{ env.DEMO_SERVER }} << 'EOF'
            rm -rf /home/ubuntu/Udemy-section5
            git clone https://github.com/sagarkakkalasworld/Udemy-section5.git
            cd Udemy-section5
            chmod 744 build.sh
            chmod 744 deploy.sh
          EOF

  build:
    name: Build Stage
    needs: pre-requisites
    runs-on: [self-hosted, cicd]
    steps:
      - name: Run build.sh
        run: |
          ssh -o StrictHostKeyChecking=no ubuntu@${{ env.DEMO_SERVER }} "bash /home/ubuntu/Udemy-section5/build.sh"

  deploy:
    name: Deploy Stage
    needs: build
    runs-on: [self-hosted, cicd]
    steps:
      - name: Run deploy.sh
        run: |
          ssh -o StrictHostKeyChecking=no ubuntu@${{ env.DEMO_SERVER }} "bash /home/ubuntu/Udemy-section5/deploy.sh"
```

---

## 🔁 Trigger Types

The workflow is triggered on:

* Git tag pushes (e.g., `v1.0.0`)
* Manual runs using `workflow_dispatch`

---
## Connect with Me

* [📺 YouTube - Sagar Kakkala's World](https://www.youtube.com/@sagarkakkala)
* [📁 20 Day-DevOps to GitOps Project (YouTube Playlist)](https://www.youtube.com/playlist?list=PLlMNTzKKV4R585f9o-Og8Cd4V9sc6w8yA)
* [💼 LinkedIn - Sagar Kakkala](https://www.linkedin.com/in/sagar-kakkala)
* [📝 Blog - Sagar Kakkala's World](https://www.sagarkakkalasworld.com/p/contents-of-blog-sagar-kakkalas-world.html)
* [🌐 One Stop - Linktree](https://linktr.ee/sagar_kakkalas_world)

---

🖊 **Feedback, queries, and suggestions are welcome in the comments!**


---

Let me know if you'd like to add badges, project screenshots, or sections like “Why Self-Hosted Runners?” or “Security Considerations.”
```
