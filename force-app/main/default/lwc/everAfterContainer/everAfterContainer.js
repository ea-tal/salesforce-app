import { LightningElement, wire, api } from 'lwc';
import getDataFromEverAfter from '@salesforce/apex/EverAfterService.getDataFromEverAfter'

const events = {
    EMBEDDED_PAGE_VIEW : 'A new embedded page view',
    SHARED_PAGE_VIEW : 'A new shared page view',
    UPDATED_MEETING_AGENDA : 'Meeting agenda was updated',
    COLLABORATION_CHANGES : 'A shared notes widget was updated',
    TABLE_EDIT : 'A table was edited',
    KPI_UPDATE : 'KPI was updated',
    CRM_RECORD_ADDED_BY_CUSTOMER : 'Customer added a record',
    CRM_RECORD_UPDATED_BY_CUSTOMER : 'Customer updated a record',
    ALERT_WIDGET_CTA : 'Clicked button on alert widget',
    SURVEY_RESPONSE : 'A new survey response',
    TASK_COMPLETED : 'Task completed',
    TASK_STARTED : 'Task started',
    TASK_FILE_UPLOADED : 'File uploaded to a task',
    TASK_EDIT_BY_CUSTOMER : 'Customer edited a task',
    TASK_CREATED_BY_CUSTOMER : 'Customer created a task',
    TASK_UPDATED_WITH_API : 'Task API update',
    NEW_COMMENT_EVENT : 'New comment added',
    NEW_COMMENT_REPLY_EVENT : 'New reply on comment'
}

export default class EverAfterContainer extends LightningElement {

    isLoading = true
    recordsFound = false
    noRecordsFound = false
    error = false
    rows = []
    @api recordId

    @wire(getDataFromEverAfter, { accId: '$recordId' }) events ({error, data}) {
        if (data) {
            this.isLoading = false
            const array = []
            data.forEach(elem => {
                const event = {}
                event.Id = elem.Ever_after_Id
                event.type = elem.Type
                event.user = elem.End_User
                event.event = events[elem.Type]
                event.when = this.handleCreatedAt(elem.Created_at_ever_after)
                event.time = Date.parse(elem.Created_at_ever_after)
                array.push(event)
            })
            this.rows = [...array]
            this.rows.sort((prev, next) => next.time - prev.time)
            if (array.length > 0) {
                this.recordsFound = true
            } else {
                this.noRecordsFound = true
            }
        } else if (error) {
            this.isLoading = false
            this.error = true
        }
    }

    handleCreatedAt(createdAt) {
        const now = new Date()
        const nowTime = Date.parse(now)
        const createdAtTime = Date.parse(createdAt)
        const difference = (nowTime - createdAtTime) / 60000
        if (difference > 1440) {
            return parseInt(difference / 1440) + ' days ago'
        } else if (difference <= 1440 && difference > 60) {
            return parseInt(difference / 60) + ' hours ago'
        } else if (difference <= 60 && difference > 1) {
            return parseInt(difference) + ' minutes ago'
        } else {
            return 'recently'
        }
    }
}