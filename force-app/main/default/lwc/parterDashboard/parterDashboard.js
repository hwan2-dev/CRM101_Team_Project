import { LightningElement } from 'lwc';

export default class ParterDashboardHeader extends LightningElement {
    currentDate;

    connectedCallback() {
        const today = new Date();
        const year = today.getFullYear();
        const month = (today.getMonth() + 1).toString().padStart(2, '0');
        const day = today.getDate().toString().padStart(2, '0');
        
        this.currentDate = `${year}-${month}-${day}`;
    }
}