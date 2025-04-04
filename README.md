# CRM101_Team_Project 🚀  

![Salesforce](https://img.shields.io/badge/Salesforce-00A1E0?style=flat&logo=Salesforce&logoColor=white)
![Apex](https://img.shields.io/badge/Apex-009EDB?style=flat&logo=Salesforce&logoColor=white)
![LWC](https://img.shields.io/badge/LWC-FF9900?style=flat&logo=Lightning&logoColor=white)

## 📌 프로젝트 개요  
**Salesforce CRM을 활용하여 팝업스토어 운영을 최적화**하는 프로젝트입니다.  
가상의 기업 "더미래"는 매출 1위 백화점을 목표로 하며, 이를 위해 **팝업스토어 유치, 브랜드 관리, 장기입점 평가, 매출 분석을 효율적으로 수행**해야 합니다.  

이 프로젝트에서는 Salesforce Sales Cloud, Service Cloud, Experience Cloud를 활용하여  
**브랜드 리드 관리, 자동화된 MD 평가 시스템, 매출 분석 기능을 구축**하였습니다.  

---

## 💡 주요 기능  
### 🎯 브랜드 리드 관리  
- Sales Cloud를 활용하여 브랜드 리드 데이터를 한 곳에서 통합 관리  

### 📊 자동화된 MD 평가 시스템  
- Flow 및 Apex Trigger를 활용하여 평가서를 자동 생성  
- 평가 점수를 기반으로 브랜드의 장기입점 가능성을 예측  

### 📈 매출 분석 및 대시보드  
- Tableau를 연동하여 매출 데이터를 시각화  
- 인기 브랜드의 재고 소진 가능성을 예측하여 사전 대응 가능  

---

## 🛠 기술 스택 (Tech Stack)
| 영역       | 사용 기술 |
|------------|--------------------------------|
| **Edition** | Salesforce Developer Edition |
| **Clouds** | Sales Cloud, Experience Cloud, Service Cloud|
| **Development** | Apex, LWC, Flow, SOQL |
| **Frontend** | HTML, CSS, JavaScript |
| **IDE & CLI** | VS Code, Salesforce CLI |
| **Collaboration** | Jira, Miro, Slack, Google Drive |
| **API & Testing** | Postman |
| **Dashboard & Reporting** | Tableau |

---

## 📂 프로젝트 구조  
```
CRM101_Team_Project/
│-- force-app/
│   ├── main/
│   │   ├── default/
│   │   │   ├── classes/
│   │   │   │   ├── controllers/
│   │   │   │   ├── repositories/
│   │   │   │   ├── services/
│   │   │   │   ├── triggers/
│   │   │   │   ├── webservices/
│   │   │   │   │   ├── rest/
│   │   │   ├── lwc/
│   │   │   │   ├── neswList/
│   │   │   │   ├── parterDashboard/
│   │   │   ├── triggers/
```
---

## 📐 ERD
![THE MIRAE_ERD (간략화)](https://github.com/user-attachments/assets/9172eb5b-7b90-4d4b-8738-99b74ea91f9d)

---

## 📌 My Contribution  
### 🔹 개발 범위  
- **LWC 컴포넌트 개발** : Naver News API를 연동하여, 담당 매장의 실시간 뉴스 정보를 조회할 수 있는 컴포넌트 구현
- **Apex 트리거 개발** : 리드(Lead) 생성 시, 관련 브랜드의 최신 기사를 자동으로 조회하여 커스텀 오브젝트에 저장 (리드와 Lookup 관계 설정)
- **Flow 자동화** : 정기MD평가 레코드 생성 시, 자동 알림 및 이메일 발송 프로세스 구축
- - **Tableau Public을 활용한 매출 데이터 시각화** : 외부 DB 연동 및 실시간 처리는 어려웠지만, Tableau Public을 활용해 브랜드 매출 데이터를 시각화하고, 이를 LWC에서 임베딩하여 Experience Cloud 포털에 노출되도록 구현

---


