import { LightningElement, api, wire, track } from "lwc";
import retrieveOpps from "@salesforce/apex/SearchOpportunities.retriveOpps";
import sendDataRest from "@salesforce/apex/SearchOpportunities.sendDataRest";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

export default class OpportunitySearch extends NavigationMixin(
  LightningElement
) {
  @track errorMsg = "";
  strSearchOppName = "";
  @track rec;
  @track error;
  @track listAccsData = [];
  @track page = 1; //this will initialize 1st page
  @track items = []; //it contains all the records.
  @track data = []; //data to be display in the table
  @track columns; //holds column info.
  @track startingRecord = 1; //start record position per page
  @track endingRecord = 0; //end record position per page
  @track pageSize = 20; //default value we are assigning
  @track totalRecordCount = 0; //total record count received from all retrieved records
  @track totalPage = 0; //total number of page is needed to display all records

  handleOppName(event) {
    this.strSearchOppName = event.detail.value;
  }
  handleSearch() {
    if (this.strSearchOppName == "") {
      const evt = new ShowToastEvent({
        title: "",
        message: "No Record Found",
        variant: "error"
      });
      this.dispatchEvent(evt);
    } else {
      retrieveOpps({
        searchString: this.strSearchOppName
      })
        .then((result) => {
          this.items = result;
          this.totalRecordCount = result.length;
          this.totalPage = Math.ceil(this.totalRecordCount / this.pageSize);
          this.data = this.items.slice(0, this.pageSize);
          this.endingRecord = this.pageSize;
        })
        .catch((error) => {
          window.console.log("error =====> " + JSON.stringify(error));
          if (error) {
            const evt = new ShowToastEvent({
              title: "",
              message: error.body.message,
              variant: "error"
            });
            this.dispatchEvent(evt);
          }
        });
    }
  }
  previousHandler() {
    if (this.page > 1) {
      this.page = this.page - 1; //decrease page by 1
      this.displayRecordPerPage(this.page);
    }
  }

  nextHandler() {
    if (this.page < this.totalPage && this.page !== this.totalPage) {
      this.page = this.page + 1; //increase page by 1
      this.displayRecordPerPage(this.page);
    }
  }

  //this method displays records page by page
  displayRecordPerPage(page) {
    /*let's say for 2nd page, it will be => "Displaying 6 to 10 of 23 records. Page 2 of 5"
    page = 2; pageSize = 5; startingRecord = 5, endingRecord = 10
    so, slice(5,10) will give 5th to 9th records.
    */
    this.startingRecord = (page - 1) * this.pageSize; //(2-1)*20=20
    this.endingRecord = this.pageSize * page; //(20*2)=40
    // if its the last record or not
    this.endingRecord =
      this.endingRecord > this.totalRecordCount
        ? this.totalRecordCount
        : this.endingRecord;

    this.data = this.items.slice(this.startingRecord, this.endingRecord);

    //increment by 1 to display the startingRecord count,
    //so for 2nd page, it will show "Displaying 6 to 10 of 23 records. Page 2 of 5"
    this.startingRecord = this.startingRecord + 1;
  }

  async handleOpenOpps(event) {
    const url = await this[NavigationMixin.GenerateUrl]({
      type: "standard__recordPage",
      attributes: {
        recordId: event.target.value,
        objectApiName: "Opportunity",
        actionName: "view"
      }
    });
    window.open(url, "_blank");
  }
  async handleOpenAccs(event) {
    const url = await this[NavigationMixin.GenerateUrl]({
      type: "standard__recordPage",
      attributes: {
        recordId: event.target.value,
        objectApiName: "Account",
        actionName: "view"
      }
    });
    window.open(url, "_blank");
  }
  sendRecord(event) {
    var recId = event.target.dataset.id;
    sendDataRest({ selectedId: recId })
      .then((result) => {
        this.rec = result;
      })
      .catch((error) => {
        this.rec = undefined;
        window.console.log("error =====> " + JSON.stringify(error));
        if (error) {
          const evt = new ShowToastEvent({
            title: "",
            message: error.body.message,
            variant: "error"
          });
          this.dispatchEvent(evt);
        }
      });
    if (this.rec == "success") {
      const evt = new ShowToastEvent({
        title: "Success",
        message: "Sent successfully",
        variant: "success"
      });
      this.dispatchEvent(evt);
    } else {
      const evt = new ShowToastEvent({
        title: "Failed",
        message: "Sending failed",
        variant: "error"
      });
      this.dispatchEvent(evt);
    }
  }
}
