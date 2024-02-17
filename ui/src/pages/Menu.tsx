import { Button } from '@/components/ui/button';
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { ScrollArea } from '@/components/ui/scroll-area';
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Separator } from '@/components/ui/separator';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { cuisines } from '@/lib/MenuCuisines';
import { Star } from 'lucide-react';
import { SyntheticEvent, useEffect, useRef, useState } from 'react';
import {
  getStorage,
  uploadBytesResumable,
  getDownloadURL,
  ref,
} from 'firebase/storage';
import { generateHex } from '@/lib/utils';
import { uploadFileToFirebase } from '@/lib/firebase-upload-file';
import { app } from '@/lib/firebase';

function Menu() {
  const items = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  const [isEditing, setIsEditing] = useState(false);

  function toggleEditMode(id: number | null) {
    console.log('hi', id);
    if (id != null) {
      setIsEditing(true);
    } else {
      setIsEditing(false);
    }
  }

  return (
    <div className="hidden flex-col md:flex">
      <div className="flex-1 space-y-4 p-8 pt-6">
        <div className="flex items-center justify-between space-y-2">
          <h2 className="text-3xl font-bold tracking-tight">Menu</h2>
        </div>
        <Tabs defaultValue="add" className="space-y-4">
          <TabsList>
            <TabsTrigger value="view">View menu</TabsTrigger>
            <TabsTrigger value="add">Add item</TabsTrigger>
          </TabsList>
          {isEditing ? (
            <EditItem exitEditingMode={toggleEditMode} />
          ) : (
            <ViewMenu items={items} enterEditingMode={toggleEditMode} />
          )}
          <AddItem />
        </Tabs>
      </div>
    </div>
  );
}

function EditItem({ exitEditingMode }) {
  return (
    <TabsContent value="view">
      <Card>
        <Button
          onClick={() => {
            exitEditingMode();
          }}
        >
          Save
        </Button>
      </Card>
    </TabsContent>
  );
}

function ViewMenu({ items, enterEditingMode }) {
  return (
    <TabsContent value="view">
      <Card>
        <CardContent className="px-1 py-0 h-[70vh]">
          <ScrollArea className=" py-2 h-full">
            <div className="w-full grid grid-cols-4 gap-5 px-4">
              {items.map((item, index) => {
                return (
                  <Card
                    key={index}
                    className="rounded-3xl overflow-hidden drop-shadow-lg aspect-[5/6]"
                  >
                    <CardContent className="flex flex-col p-0">
                      <img
                        src="https://img.delicious.com.au/R0F10d9O/w759-h506-cfill/del/2015/10/cassata-semifreddo-15858-2.jpg"
                        className="w-full object-cover"
                      />
                      <div className="flex flex-col px-3 pb-2 font-semibold text-xl">
                        <div className="w-full flex justify-between">
                          Ice Cream
                        </div>
                        <div className="w-full flex justify-between mt-1">
                          <p>₹ 100</p>
                          <p className="flex items-center">
                            <Star className="stroke-amber-400" /> <p>4.7</p>
                          </p>
                        </div>
                      </div>
                      <div className="flex justify-between px-3 gap-2">
                        <Button
                          variant={'secondary'}
                          className="border-slate-300 border-2 flex-1"
                          /* TODO: add id here */
                          onClick={() => enterEditingMode(item)}
                        >
                          Edit
                        </Button>
                        <Button className="flex-1">Delete</Button>
                      </div>
                    </CardContent>
                  </Card>
                );
              })}
            </div>
          </ScrollArea>
        </CardContent>
      </Card>
    </TabsContent>
  );
}

type customization = {
  name: string;
  amount: number;
};

function AddItem() {
  const formRef = useRef();
  const imgRef = useRef();
  const fbApp = app;
  const storage = getStorage();

  const [customizations, setCustomizations] = useState<customization[]>([]);
  const [previewImage, setPreviewImage] = useState('');
  const [categoryDropDown, setCategoryDropDown] = useState(null);
  const [cuisineDropdown, setCuisineDropdown] = useState(null);

  function onImageChange(event: SyntheticEvent) {
    if (event.target.files && event.target.files[0]) {
      console.log('got image');
      setPreviewImage(URL.createObjectURL(event.target.files[0]));
    }
  }

  async function prepareDataForApiRequest() {
    if (formRef.current) {
      const name = formRef.current[0].value;
      const description = formRef.current[1].value;
      const amount = formRef.current[2].value;
      const quantity = formRef.current[3].value;
      const category = categoryDropDown;
      const cuisine = cuisineDropdown;
      const customization = customizations;

      const imageFile = imgRef.current.files[0];
      const uploadFileName = generateHex() + imageFile.name;
      const metadata = {
        name: imageFile.name,
        size: imageFile.size,
        contentType: imageFile.type,
      };

      console.log(imageFile.file, metadata, uploadFileName);

      // const storageRef = ref(storage, 'menu/' + uploadFileName);
      // const uploadTask = uploadBytesResumable(
      //   storageRef,
      //   imageFile.file,
      //   metadata
      // );
      // uploadFileToFirebase(uploadTask);
      // await uploadTask;
      // const url = await getDownloadURL(uploadTask.snapshot.ref);
      // console.log('uploaded file:', url);
    }
  }

  return (
    <TabsContent value="add" className="flex justify-center items-center">
      <Card className="w-[750px]">
        <CardHeader>
          <CardTitle>Add imageFile</CardTitle>
          <CardDescription>Add a new item to the menu</CardDescription>
        </CardHeader>
        <CardContent>
          <form ref={formRef} className="flex flex-col space-y-4">
            <div className="flex gap-4">
              <div className="flex-1 flex flex-col space-y-4">
                <Input placeholder="Name" name="name" />
                <Input placeholder="Description" name="description" />
                <Input placeholder="Price" name="price" type="number" />
                <Input placeholder="Quantity" name="quantity" type="number" />
                <div className="gap-3 flex items-center justify-start">
                  <Label>Category</Label>
                  <Select onValueChange={(e) => setCategoryDropDown(e)}>
                    <SelectTrigger className="w-[180px]">
                      <SelectValue placeholder="Select a category" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup>
                        <SelectItem value="0">Jain</SelectItem>
                        <SelectItem value="1">Veg</SelectItem>
                        <SelectItem value="2">Non Veg</SelectItem>
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                </div>
                <div className="gap-6 flex items-center justify-start">
                  <Label>Cuisine</Label>
                  <Select onValueChange={(e) => setCuisineDropdown(e)}>
                    <SelectTrigger className="w-[180px]">
                      <SelectValue placeholder="Select a Cuisine" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectGroup>
                        {cuisines.map((item, index) => {
                          return (
                            <SelectItem key={index} value={item}>
                              {item}
                            </SelectItem>
                          );
                        })}
                      </SelectGroup>
                    </SelectContent>
                  </Select>
                </div>
              </div>
              <div className="flex-1 -mt-8">
                <Label htmlFor="picture">Picture</Label>
                <Input
                  ref={imgRef}
                  id="picture"
                  type="file"
                  onChange={(e) => onImageChange(e)}
                  className="mt-2"
                />
                <img
                  id="preview-image"
                  src={previewImage}
                  className="mt-4 rounded-md"
                />
              </div>
            </div>
            <div className="flex flex-col space-y-2">
              <Label>Customization</Label>
              <Button
                type="button"
                className="w-fit"
                onClick={() =>
                  setCustomizations((state) => [
                    ...state,
                    { name: '', amount: 0 },
                  ])
                }
              >
                Add
              </Button>
              <div className="space-y-4 flex flex-col">
                {customizations.map((item, index) => {
                  return (
                    <CustomizationPill
                      customization={item}
                      setCustomization={setCustomizations}
                      index={index}
                      key={index}
                    />
                  );
                })}
              </div>
            </div>
            <Button
              onClick={(e) => {
                e.preventDefault();
                prepareDataForApiRequest(e);
              }}
            >
              Submit
            </Button>
          </form>
        </CardContent>
      </Card>
    </TabsContent>
  );
}

function CustomizationPill({ customization, setCustomization, index }) {
  return (
    <div className="flex gap-2">
      <Input
        value={customization.name}
        placeholder="Name"
        onChange={(e) => {
          setCustomization((state) => [
            ...state.slice(0, index),
            { name: e.target.value, amount: state[index].amount },
            ...state.slice(index + 1),
          ]);
        }}
      />
      <Input
        value={customization.amount}
        placeholder="Amount"
        type="number"
        onChange={(e) => {
          setCustomization((state) => [
            ...state.slice(0, index),
            { name: state[index].name, amount: e.target.value },
            ...state.slice(index + 1),
          ]);
        }}
      />
      <Button
        onClick={(e) => {
          e.preventDefault();
          setCustomization((state) => [
            ...state.slice(0, index),
            ...state.slice(index + 1),
          ]);
        }}
      >
        Remove
      </Button>
    </div>
  );
}

export default Menu;
