import { LightningElement, api, wire } from "lwc";
import Id from "@salesforce/user/Id";

export default class WalletPage extends LightningElement {
  userId = Id;
}