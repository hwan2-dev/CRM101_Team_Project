import { LightningElement, wire, track, api } from 'lwc';
import getNaverNewsList from '@salesforce/apex/NaverNewsApiController.getNaverNewsList';
import getEnterOrNotValues from '@salesforce/apex/OpportunityController.getEnterOrNotValues';
import getOpportunitiesByStatus from '@salesforce/apex/OpportunityController.getOpportunitiesByStatus';

export default class NewsList extends LightningElement {
    newsArticles = [];
    isLoading = false;
    isNull = false;
    isNewsEmpty = false;
    storeOptions = []; // 매장 목록 (선택된 입점 상태에 따라 변경)
    selectedStore = '';
    selectedStores = []; // 선택된 매장 목록
    statusOptions = [];
    error;
    selectedStatus = '';    // 사용자가 선택한 Picklist 값
    selectedSearchFilter = 'date';
    filter = true;

    // 검색 필터 옵션 추가
    searchOptions = [
        { label: '최신순', value: 'date' },
        { label: '정확도순', value: 'sim' }
    ];


    // 검색 필터 변경 핸들러
    handleSearchFilterChange(event) {
        this.selectedSearchFilter = event.detail.value;
        localStorage.setItem('selectedSearchFilter', this.selectedSearchFilter)
    }


    @wire(getEnterOrNotValues)  // Apex 메서드에 전달하는 파라미터
    // @wire 데코레이터를 사용하여 비동기적으로 데이터를 가져옴 (Apex 호출)
    // Apex 메서드 getEnterOrNotValues를 호출하여 Enter_Or_Not__c 필드의 값을 가져옴
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.statusOptions = data.map(option => ({ label: option.label, value: option.value }));
        } else if (error) {
            console.error('⚠ Picklist 값 가져오기 실패:', error);
        }
    }

    // 뉴스 API 조회 함수
    handleFetchNews() {
        this.isLoading = true;

        // 선택한 매장 목록에서 매장 이름을 변수에 담음
        const storeNames = this.selectedStores.map(store => store.label);

        // API 호출 메소드 실행
        getNaverNewsList({ paramList: storeNames , searchFilter: this.selectedSearchFilter})
            .then(result => {
                if(result == null) {
                    this.isNull = true;
                    this.isNewsEmpty = false;
                    this.newsArticles = [];
                    localStorage.setItem('newsArticles', null);
                } else {
                    if (result.length > 0) {
                        this.isNull = false;
                        this.isNewsEmpty = false;
                        this.newsArticles = result;
                        localStorage.setItem('newsArticles', JSON.stringify(result));
                    } else {
                        this.isNull = false;
                        this.isNewsEmpty = true;
                        this.newsArticles = [];
                        localStorage.setItem('newsArticles', JSON.stringify(result));
                    }
                }
                this.error = undefined; 
            })
            .catch(error => {
                this.isNull = false;
                this.isNewsEmpty = false;
                this.newsArticles = [];
                this.error = error;
                localStorage.setItem('newsArticles', null);
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    // [화면 켜지면 실행되는 함수]
    connectedCallback() {

        // 뉴스 목록 유지
        const newsArticles = localStorage.getItem('newsArticles');
        if (newsArticles != null) {
            this.newsArticles = JSON.parse(newsArticles);
        }

        // 입점 상태 필터 값 유지
        const selectedStatus = localStorage.getItem('selectedStatus');
        this.selectedStatus = selectedStatus;

        // [입점 상태 변경 시 실행되는 함수] 호출
        this.handleStatusChange();

        // 선택한 매장 목록 유지
        const selectedStores = localStorage.getItem('selectedStores');
        this.selectedStores = selectedStores ? JSON.parse(selectedStores) : [];

        // 검색 필터 값 유지
        const selectedSearchFilter = localStorage.getItem('selectedSearchFilter')
        this.selectedSearchFilter = localStorage.getItem('selectedSearchFilter') ? selectedSearchFilter : 'date';
    }

    // 해당 url로 이동하기
    // handleNavigate(event) {
    //     const url = event.target.value; // value 속성으로 가져오기
    //     console.log('📌 클릭한 버튼의 URL:', url);
    
    //     if (url) {
    //         window.open(url, '_blank');
    //     } else {
    //         console.error('⚠ URL이 존재하지 않습니다.');
    //     }
    // }
    
    // [입점 상태 변경 시 실행되는 함수]
    handleStatusChange(event) {

        // 이벤트가 들어왔을 때 실행되는 if문
        if(event !== undefined) {
            this.selectedStatus = event.detail.value;
        }

        // [선택한 입점 상태에 따라 매장 목록 가져오기 함수] 호출
        this.fetchOpportunities();

        // 매장 필터 강제 UI 업데이트
        if(this.selectedStore === '' || this.selectedStore === null) {
            this.selectedStore = undefined;
        } else if(this.selectedStore === undefined) {
            this.selectedStore = null;
        }

        // 선택한 입점 상태를 로컬 스토리지에 저장
        localStorage.setItem('selectedStatus', this.selectedStatus);
    }

    // [선택한 입점 상태에 따라 매장 목록 가져오기 함수]
    fetchOpportunities() {
        getOpportunitiesByStatus({ status: this.selectedStatus })   // 매장 목록 조회
            .then(result => {
                // 매장 목록 호출 결괏값을 옵션으로 변환
                this.storeOptions = result.map(opp => (
                    { label: opp.Account.Name, value: opp.Account.Name }
                ));

                // 매장 목록 호출 결괏값이 1개 이상일 때 "전체 선택" 옵션 추가
                if (this.storeOptions.length > 0) {
                    this.storeOptions.unshift({ label: '전체 선택', value: 'all' });
                }
            })  
            .catch(error => {
                console.error('매장 목록 가져오기 실패 : ', error);
                this.storeOptions = [];
            });
    }

    // 매장 목록에서 선택 시 배찌 추가하는 함수
    handleStoreSelection(event) {
        const selectedValue = event.detail.value;
        const selectedLabel = this.storeOptions.find(store => store.value === selectedValue)?.label;
    
        if (selectedValue === 'all') {
            const newStores = this.storeOptions
                .filter(store => store.value !== 'all') // "전체 선택" 제외
                .filter(store => !this.selectedStores.some(selected => selected.value === store.value)) // 기존 선택된 항목 제외
                .map(store => ({ label: store.label, value: store.value })); 
    
            this.selectedStores = [...this.selectedStores, ...newStores]; // 기존 선택 유지하고 추가
        } else {
            // 개별 매장 선택
            if (selectedValue && selectedLabel) {
                // 중복 방지 후 추가
                if (!this.selectedStores.some(store => store.value === selectedValue)) {
                    this.selectedStores = [...this.selectedStores, { label: selectedLabel, value: selectedValue }];
                }
            }
        }

        localStorage.removeItem('selectedStores');
        localStorage.setItem('selectedStores', JSON.stringify(this.selectedStores));
    }

    // X 버튼 클릭 시 매장 제거
    handleRemoveStore(event) {
        if(this.selectedStore === '' || this.selectedStore === null) {
            this.selectedStore = undefined;
        } else if(this.selectedStore === undefined) {
            this.selectedStore = null;
        }

        const storeValueToRemove = event.currentTarget.dataset.value;
        this.selectedStores = this.selectedStores.filter(store => store.value !== storeValueToRemove);

        // UI 업데이트 강제 적용
        this.selectedStores = [...this.selectedStores];

        localStorage.removeItem('selectedStores');
        localStorage.setItem('selectedStores', JSON.stringify(this.selectedStores));
    }
}