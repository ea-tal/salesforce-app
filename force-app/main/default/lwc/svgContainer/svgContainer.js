import { LightningElement, api } from 'lwc';

const viewActions = ['EMBEDDED_PAGE_VIEW', 'SHARED_PAGE_VIEW']

const updateActions = ['UPDATED_MEETING_AGENDA', 'COLLABORATION_CHANGES', 'TABLE_EDIT', 'KPI_UPDATE',
'CRM_RECORD_ADDED_BY_CUSTOMER', 'CRM_RECORD_UPDATED_BY_CUSTOMER', 'ALERT_WIDGET_CTA', 
'SURVEY_RESPONSE']

const taskActions = ['TASK_COMPLETED', 'TASK_STARTED', 'TASK_FILE_UPLOADED', 'TASK_EDIT_BY_CUSTOMER',
'TASK_CREATED_BY_CUSTOMER', 'TASK_UPDATED_WITH_API']

const commentActions = ['NEW_COMMENT_EVENT', 'NEW_COMMENT_REPLY_EVENT']

export default class SvgContainer extends LightningElement {

    comment = false
    task = false
    update = false
    view = false
    @api type

    connectedCallback() {
        if (viewActions.includes(this.type)) {
            this.view = true
        } else if (updateActions.includes(this.type)) {
            this.update = true
        } else if (taskActions.includes(this.type)) {
            this.task = true
        } else if (commentActions.includes(this.type)) {
            this.comment = true
        }
    }
}